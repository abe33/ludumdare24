package ludum.boot
{
    import flash.text.TextFormat;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.text.TextField;

    /**
     * @author cedric
     */
    public class EvolutionBoot extends BootLoader
    {
        [Embed(source='../../../assets/swf/gfx.swf', symbol='gfx.Balance')]
        static public const BALANCE: Class; 
        
        protected var _container : Sprite;
        private var _balance : MovieClip;
        private var _txt : TextField;
        
        public function EvolutionBoot ()
        {
            super ();
        }
        
        override protected function createProgressPanel () : void
        {
            _container = new Sprite();
            addChild(_container);
            
            _balance = new BALANCE() as MovieClip;
            _balance.x = 320;
            _balance.y = 480;
            _balance.scaleX = _balance.scaleY = 2;
            
            _txt = new TextField();
            _txt.defaultTextFormat = new TextFormat("Arial", 20, 0xffffff, true, false, false, null, null, "center");
            _txt.width = 640;
            _txt.y = 50;
            
            _container.addChild(_balance);
            _container.addChild(_txt);
            
        }
        
        override protected function releaseProgressPanel () : void
        {
            removeChild(_container);
        }
        override protected function setProgressLabel ( s : String ) : void
        {
        }
        override protected function setProgressValue ( n : Number ) : void
        {
            _balance.gotoAndStop(Math.floor(n)+1);
            _txt.text = "LOADING...\n" + Math.floor(n) + "%";
        }
        
    }
}
