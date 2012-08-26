package ludum.states
{
    import abe.com.edia.commands.SimpleFadeIn;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;
    import abe.com.mon.colors.Color;
    import abe.com.mon.utils.StageUtils;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.utils.ToolKit;

    import ludum.Constants;
    import ludum.game.Player;

    import flash.display.Sprite;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    import flash.ui.Mouse;

    /**
     * @author cedric
     */
    public class EndState extends AbstractUIState
    {        
        private var continueBt : Button;
        private var gui : Sprite;
        private var stats : Object;
        public function EndState ()
        {
            super ();
        }
        override public function activate ( previousState : UIState ) : void
        {
            
            Mouse.show();
            var player : Player = (previousState as PlayState).board.player;
            
            CONFIG::RELEASE
            {     
	            var vars : URLVariables = new URLVariables();
	            vars.total = player.total;
	            vars.white = player.whiteAmount;
	            vars.black = player.blackAmount;
	            
	            var request: URLRequest = new URLRequest(StageUtils.root.loaderInfo.parameters.callbackURL);
	            request.method = URLRequestMethod.POST;
	            request.data = vars;
	            
	            var loader:URLLoader = new URLLoader();
	            loader.load(request);   
            }
            new SimpleFadeIn(ToolKit.popupLevel, Color.Black).execute();
            
            gui = new Sprite();
            continueBt = new Button("Continue");            
            continueBt.actionTriggered.add(submit);
            
            gui.addChild(continueBt);
            
            ToolKit.mainLevel.addChild(gui);

            StageUtils.centerX(continueBt);
            continueBt.y = Constants.HEIGHT - 120;
            
            SoundManagerInstance.playSound("loop", 0.5, 0, -1);
        }

        protected function submit (... args) : void
        {
            CONFIG::RELEASE
            {
	            var request: URLRequest = new URLRequest(StageUtils.root.loaderInfo.parameters.redirectURL);
                
                navigateToURL(request, "_self");
            }
            CONFIG::DEBUG
            {
                _manager.goto("start");
            }
        }

        override public function release () : void
        {
            continueBt.actionTriggered.remove(submit);
            ToolKit.mainLevel.removeChild(gui);
            super.release ();
            SoundManagerInstance.stopSound('loop');
        }
    }
}
