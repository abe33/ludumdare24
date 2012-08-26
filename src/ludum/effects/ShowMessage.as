/**
 * @license
 */
package ludum.effects 
{
    import abe.com.edia.text.AdvancedTextField;
    import abe.com.mands.AbstractCommand;
    import abe.com.mands.Command;
    import abe.com.mands.Timeout;
    import abe.com.mon.core.Runnable;
    import abe.com.mon.core.Suspendable;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.utils.ToolKit;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
	/**
	 * @author Cédric Néhémie
	 */
	public class ShowMessage extends AbstractCommand implements Suspendable, Command, Runnable
	{
		protected var _txt : AdvancedTextField;
		protected var _message : String;
		protected var _commandEndTimeout : Number;
		protected var _args : Array;
		protected var _timeout : Timeout;
		protected var _autoHideLaunch : Boolean;
		
		static public const SHOW_EFFECT_ID : String = "show";
		static public const HIDE_EFFECT_ID : String = "hide";
		
		public var isActive : Boolean;

		public function ShowMessage ( message : String, commandEndTimeout : Number = 3000, autoHideLaunch : Boolean = false, ... args )
		{
			_message = message;
			_commandEndTimeout = commandEndTimeout;
			_autoHideLaunch = autoHideLaunch;
			_args = args;
			_txt = new AdvancedTextField();
			
			if( _commandEndTimeout != -1 )
				_timeout = new Timeout( clearSpeech, _commandEndTimeout );
		}

		override public function execute ( ... args ) : void
		{
			showMessage();
		}
		
		protected function formatMessage ( str : String ) : String
		{
			return str;
		}
		
		protected function setupBeforeAffectation () : void
		{
			_txt.wordWrap = true;
			_txt.autoSize = "left";
			_txt.multiline = true;
			_txt.width = StageUtils.stage.stageWidth-40;
		}
		protected function setupAfterAffectation () : void
		{
			var bb : Rectangle = _txt.getBounds( ToolKit.mainLevel );
			
			_txt.x = 20;
			_txt.y = ( StageUtils.stage.stageHeight - _txt.height ) - bb.y - 20;

		}
		protected function showMessage () : void
		{	
			isActive = true;
			
			setupBeforeAffectation();
			_txt.htmlText = formatMessage( _message );
			setupAfterAffectation();
			
			if( _txt.build.effects.hasOwnProperty( HIDE_EFFECT_ID ) )
				_txt.build.effects[HIDE_EFFECT_ID].addEventListener ( Event.COMPLETE, clearSpeech );
			
			if( _timeout )
				_timeout.execute();
                
             ToolKit.popupLevel.addChild(_txt);
             StageUtils.centerX(_txt);
             StageUtils.centerY(_txt);
		}		

		public function clearSpeech ( e : Event = null ) : void
		{
			isActive = false;
			
			if( ToolKit.popupLevel.contains( _txt ) )
				ToolKit.popupLevel.removeChild( _txt );
			
			if( _timeout && _timeout.isRunning() )
				_timeout.stop();
				
			_txt.clear();
			_txt = null;
			_args = null;
			
			_commandEnded.dispatch( this );
		}
		
		protected function launchHide (event : Event) : void
		{
			if( _txt.build.effects.hasOwnProperty(HIDE_EFFECT_ID) )
				_txt.build.effects[HIDE_EFFECT_ID].start();
		}
		
		public function start () : void
		{
			_isRunning = true;
			if( _timeout )
				_timeout.start();
			_txt.start();
		}

		public function stop () : void
		{
			_isRunning = false;
			if( _timeout )
				_timeout.stop();
			_txt.stop();
		}
	}
}
