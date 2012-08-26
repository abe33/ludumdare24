package ludum.states
{
    import abe.com.edia.commands.SimpleFadeIn;
    import abe.com.edia.commands.SimpleFadeOut;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;
    import abe.com.mon.colors.Color;
    import abe.com.ponents.utils.ToolKit;

    import ludum.assets.Misc;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.utils.setTimeout;

    /**
     * @author cedric
     */
    public class StartState extends AbstractUIState
    {
        private var gui : Sprite;
        private var splash : Bitmap;
        public function StartState ()
        {
            super ();
        }
        override public function activate ( previousState : UIState ) : void
        {
            new SimpleFadeIn(ToolKit.popupLevel, Color.Black).execute();
            
            gui = new Sprite();
            
            gui.addEventListener(MouseEvent.CLICK, play);
            
            splash = new Misc.SPLASH() as Bitmap;
            gui.addChild(splash);
            
            ToolKit.mainLevel.addChild(gui);
       
            SoundManagerInstance.playSound("loop", 0.5, 0, -1);
        }

        protected function play (... args) : void
        {
            new SimpleFadeOut(ToolKit.popupLevel, Color.Black).execute();
            setTimeout(function():void{_manager.goto('story');}, 500);
        }

        override public function release () : void
        {
            splash.bitmapData.dispose();
            gui.removeEventListener(MouseEvent.CLICK,play);
            ToolKit.mainLevel.removeChild(gui);
            super.release ();
        }
    }
}
