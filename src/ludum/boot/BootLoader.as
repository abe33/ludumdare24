package ludum.boot
{
    import abe.com.patibility.codecs.MOCodec;
    import abe.com.patibility.codecs.POCodec;

    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.getDefinitionByName;
    import flash.utils.setTimeout;

    /**
     * @author cedric
     */
    public class BootLoader extends MovieClip
    {
        /*
         * use -define+=CONFIG::MAIN_CLASS,"path.to::Class" as build option
         * to setup the concret entry point
         */ 
        static protected var __mainClassName__ : String = CONFIG::MAIN_CLASS;
        
        private var _app : DisplayObject;
        private var _numLangFile : int;
        private var _currentLangFile : int;
        private var _loaders : Array;
        private var _downloadDatas : Dictionary;
        private var _translations : Object;
        
        public function BootLoader ()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            stop();
            
            CONFIG::DEBUG {
                createDebug();
                debug("Boot init");
            }
            
            createProgressPanel();            
            setProgressLabel( getMessage("load") );
            addEventListener( Event.ENTER_FRAME, enterFrame );
        }
        
        CONFIG::DEBUG
        {
            protected var _debug : TextField;
            protected function createDebug () : void
            {
                _debug = new TextField();
                _debug.width = stage.stageWidth;
                _debug.height = stage.stageHeight;
                _debug.blendMode = "invert";
                addChild(_debug);
            }
            protected function releaseDebug():void
            {
                removeChild(_debug);
                _debug = null;            
            }
            protected function debug( o : * ):void
            {
                _debug.appendText(o + "\n");
                _debug.scrollV = _debug.maxScrollV;
            }
        }

        protected function createProgressPanel () : void {}
        protected function releaseProgressPanel() : void {}
        protected function setProgressLabel( s : String ) : void {}
        protected function setProgressValue( n : Number ) : void {}
        
        protected function getOptions () : Object
        {
            var o : Object = {};
            for ( var k : String in loaderInfo.parameters )
                o[k] = loaderInfo.parameters[k];
            
            o["translations"] = _translations;
            o["bootLoader"] = this;
            return o;
        }
        protected function getMessage ( messageId : String ) : String
        {
            switch( messageId )
            {
                case "load" :
                    if( loaderInfo.parameters.loadingMessage )
                        return loaderInfo.parameters.loadingMessage;
                    else
                        return "Loading";
                    break;
                
                case "lang" :
                    if( loaderInfo.parameters.loadingLangMessage )
                        return loaderInfo.parameters.loadingLangMessage;
                    else
                        return "Loading languages";
                    break;
                
                case "complete" :
                    if( loaderInfo.parameters.completeMessage )
                        return loaderInfo.parameters.completeMessage;
                    else
                        return "Loading complete";
                    break;
                
                default : 
                    return "";
            }
        }
        protected function languageFileCallBack ( loader : URLLoader ) : void
        {
            CONFIG::DEBUG {
                debug( loader.dataFormat );
            }
            if( loader.dataFormat == URLLoaderDataFormat.TEXT )
            {
                try
                {
                    var poc : POCodec = new POCodec ();
                    var o : Object = poc.decode ( loader.data );
                }
                catch( e : Error )
                {
                    CONFIG::DEBUG{
                        debug("unable to parse po file");
                    }
                }
            }
            else
            {
                try
                {
                    var moc : MOCodec = new MOCodec ();
                    ( loader.data as ByteArray ).endian = Endian.LITTLE_ENDIAN;
                    o = moc.decode ( loader.data );
                }
                catch( e : Error )
                {
                    CONFIG::DEBUG{
                        debug("unable to parse mo file");
                    }
                }
            }
            if( o )
            {
                for( var i : String in o.translation)
                {
                    _translations[i] = o.translation[i];
                }
            }
        }
        
        
        private function initMain () : void
        {
            try
            {
                this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
                
                var mainClass:Class = getDefinitionByName(__mainClassName__) as Class;
            
                    _app = new mainClass( getOptions() ) as DisplayObject;
                
                releaseProgressPanel();
                
                CONFIG::DEBUG {
                    releaseDebug();
                }
                
                addChild( _app );
            }
            catch(e:Error)
            {
                CONFIG::DEBUG {
	                debug( e.message );
	                debug( e.getStackTrace() );
                }
            }
        }
        private function loadLang () : void
        {
            _loaders = [];
            _downloadDatas = new Dictionary();
            _translations = {};
            
            var lang : String = this.loaderInfo.parameters.lang;
            if( lang && lang != "" )
            {
                var langs : Array = lang.split(",");
                
                _numLangFile = langs.length;
                _currentLangFile = 0;

                for( var i : uint = 0; i < _numLangFile; i++ )
                {
                    try {
                        var loader : URLLoader = new URLLoader();
                        
                        if( langs[i].substr(-2) == "mo" )
                        	loader.dataFormat = URLLoaderDataFormat.BINARY;
                            
                        loader.addEventListener( Event.COMPLETE, langLoadingComplete );
                        loader.addEventListener( ProgressEvent.PROGRESS, langLoadingProgress );
                        loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
                        loader.addEventListener( IOErrorEvent.IO_ERROR, ioError );
                        loader.load( new URLRequest( langs[i] ) );
                        
                        CONFIG::DEBUG {
                            debug("loading lang " + langs[i]);
                        }
    
                        _loaders.push( loader );
                       
                    }
                    catch(e:Error)
                    {
                        CONFIG::DEBUG {
                            debug( "failed when starting loading of " + langs[i] );
                            debug( e.message );
                        }
                        removeEventListener(Event.ENTER_FRAME, enterFrame );
                    }
                }               
                setProgressLabel( getMessage("lang") + " " + _currentLangFile + "/" + _numLangFile );
            }
            else initMain();
        }
        
        private function langLoadingComplete ( event : Event ) : void
        {
            var loader : URLLoader = event.target as URLLoader;
            loader.removeEventListener( Event.COMPLETE, langLoadingComplete );
            loader.removeEventListener( ProgressEvent.PROGRESS, langLoadingProgress );
            loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityError );
            loader.removeEventListener( IOErrorEvent.IO_ERROR, ioError );
            
            _currentLangFile++;
            setProgressLabel( getMessage("lang") + " " + _currentLangFile + "/" + _numLangFile );
            _loaders.splice( _loaders.indexOf( loader ), 1 );
            languageFileCallBack(loader);
            
            CONFIG::DEBUG {
                debug( _currentLangFile + "/" + _numLangFile + " languages files loaded" );
            }
            
            if( _loaders.length == 0 )
            {
                _loaders = null;
                _downloadDatas = null;
                CONFIG::DEBUG {
                    removeEventListener(Event.ENTER_FRAME, enterFrame );
                    setTimeout( initMain, 100 );
                }
                CONFIG::RELEASE {
                    initMain();
                }
            }
        }
        private function langLoadingProgress (event : ProgressEvent) : void 
        {
            _downloadDatas[event.target] = [ event.bytesLoaded, event.bytesTotal];
        }
        private function ioError ( event : IOErrorEvent ) : void
        {
            CONFIG::DEBUG {
                debug(event.text);
            }
        }
        private function securityError ( event : SecurityErrorEvent ) : void
        {
            CONFIG::DEBUG {
                debug(event.text);
            }
        }
		CONFIG::WITHOUT_SERVER {
            private var _n : Number = 0;
        }
        protected function enterFrame ( event : Event ) : void
        {   
            CONFIG::WITH_DISTANT_SERVER {
	            if( currentFrame == 1 )
	            {
	                setProgressValue( Math.round( loaderInfo.bytesLoaded / loaderInfo.bytesTotal * 100 ) );
	                
	                CONFIG::DEBUG {
	                    debug( "main loading" + Math.round( loaderInfo.bytesLoaded / loaderInfo.bytesTotal * 100 ) + "%" );
	                }
	                
	                if ( framesLoaded >= totalFrames ) 
	                {
	                   nextFrame();
	                   setProgressLabel( getMessage( "complete" ) );
	                   loadLang();
	                }
	            }
	            else
	            {
	                var loaded : Number = 0;
	                var total : Number = 0;
	                for each( var a : Array in _downloadDatas )
	                {
	                    loaded += a[0];
	                    total += a[1];
	                }
	                CONFIG::DEBUG {
	                    debug( "lang loading" + Math.round( ( loaded / total ) * 100 ) + "%" );
	                }
	                setProgressValue( Math.round( ( loaded / total ) * 100 ) );
	            }
            }
            CONFIG::WITHOUT_SERVER {
                if( currentFrame == 1 )
	            {
	              	if( _n < 100 )
                    {
                        setProgressValue( Math.floor( _n ) );
                    	_n++;
                        CONFIG::DEBUG {
                        	debug( "main loading" + Math.floor( _n ) + "%" );
                        }
                    }
                    else
                    {
                        nextFrame();
	                    setProgressLabel( getMessage( "complete" ) );
	                    loadLang();
                        _n = 0;
                    }
                }
                else
	            {
                    if( _n < 200 )
                    {
                        _n++;
	                    setProgressValue( Math.floor( _n / 2 ) );
                    }
                }
            }
            
        }
    }
}
