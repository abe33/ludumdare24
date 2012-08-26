package ludum.states
{
    import abe.com.edia.commands.SimpleFadeIn;
    import abe.com.edia.commands.SimpleFadeOut;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;
    import abe.com.mon.colors.Color;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.utils.ToolKit;

    import ludum.Constants;

    import flash.display.Sprite;
    import flash.utils.setTimeout;

    /**
     * @author cedric
     */
    public class StartState extends AbstractUIState
    {
        private var start : Button;
        private var gui : Sprite;
        public function StartState ()
        {
            super ();
        }
        override public function activate ( previousState : UIState ) : void
        {
            new SimpleFadeIn(ToolKit.popupLevel, Color.Black).execute();
            
            gui = new Sprite();
            start = new Button("Start");            
            
            start.actionTriggered.add(play);
            
            gui.addChild(start);
            
            ToolKit.mainLevel.addChild(gui);

            StageUtils.centerX(start);
            start.y = Constants.HEIGHT - 120;
            
            SoundManagerInstance.playSound("loop", 0.5, 0, -1);
        }

        protected function play (... args) : void
        {
            SoundManagerInstance.fadeSound('loop', 0, 500);
            new SimpleFadeOut(ToolKit.popupLevel, Color.Black).execute();
            setTimeout(function():void{_manager.goto('play');}, 500);
        }

        override public function release () : void
        {
            start.actionTriggered.remove(play);
            ToolKit.mainLevel.removeChild(gui);
            super.release ();
            
            SoundManagerInstance.stopSound('loop');
        }
    }
}
