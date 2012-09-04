package ludum.states
{
    import abe.com.mon.logs.Log;
    import ludum.game.GameBoard;
    import abe.com.edia.commands.SimpleFadeIn;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;
    import abe.com.edia.text.fx.show.DefaultTimedDisplayEffect;
    import abe.com.mon.colors.Color;
    import abe.com.mon.utils.StageUtils;
    import abe.com.mon.utils.StringUtils;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.utils.ToolKit;

    import ludum.Constants;
    import ludum.assets.Misc;
    import ludum.assets.UIButton;
    import ludum.effects.ShowMessage;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    import flash.ui.Mouse;
    import flash.utils.setTimeout;

    /**
     * @author cedric
     */
    public class EndState extends AbstractUIState
    {        
        private var continueBt : Button;
        private var gui : Sprite;
        private var stats : Object;
        private var story : Bitmap;
        public function EndState ()
        {
            super ();
        }
        override public function activate ( previousState : UIState ) : void
        {
            
            Mouse.show();
            
            var board: GameBoard = previousState ? (previousState as PlayState).board : null; 
            
	        var player : Object = board.player;
            CONFIG::RELEASE
            {     
                try               
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
                catch(e:Error)
                {	
                    
                }
            }
            new SimpleFadeIn(ToolKit.popupLevel, Color.Black).execute();
                        
            gui = new Sprite();
            story = new Misc.STORY() as Bitmap;
            
            continueBt = new UIButton("<b>CONTINUE</b>");            
            continueBt.actionTriggered.add(submit);
            
            continueBt.preferredWidth = 220;
            continueBt.rotationZ = -45;       
            continueBt.x = Constants.WIDTH-150;
            continueBt.y = Constants.HEIGHT;
            
            
            ToolKit.mainLevel.addChild(gui);
            
            setTimeout(function():void{
                DefaultTimedDisplayEffect, DropShadowFilter;
            
	            new ShowMessage(
	            	"<fx:effect type='new abe.com.edia.text.fx.show::DefaultTimedDisplayEffect(20)'>"+
		            	"<fx:filter type='new flash.filters::DropShadowFilter(0,0,0,1,4,4,2)'>"+
		                	"<p align='center'>" +
		                    	"<font color='0xffffff' size='24' face='Diogenes' embedFonts='true'>"+
					                "That's great!\n"+
									"You've destroyed <font color='0x2FB1D1'>"+ player.whiteAmount +"</font> cute fellows and " +
									"<font color='0xD13D2F'>"+ player.blackAmount +"</font> evil ones.\n"+
									"But there are still many worlds that require your attention...\n"+
                                    "\nScore\n" +
                                    "<font color='0x2FB1D1'>"+board.score.whiteScore + "</font> + " +
                                    "<font color='0xD13D2F'>"+board.score.blackScore + "</font>\n"+
                                    "<font size='32'>" + board.score.totalScore + "</font>" +
		                        "</font>" +
		                    "</p>" +
		                "</fx:filter>"+
	                "</fx:effect>", 100000000).execute();
            }, 500);
            
            
            gui.addChild(story);
                        
//            var ratioBlack: Number = player.blackAmount/ player.total;
//            var iw : int = Math.floor(50 * ratioBlack);
//            for(var i:int = 0;i<50; i++)
//            {
//                var mob: Mob = i <= iw ? new WhiteMob() : new BlackMob();
//                mob.x = 20+RandomUtils.rangeAB((i-2)/50, (i+2)/50)*(Constants.WIDTH-40);
//                mob.y = RandomUtils.rangeAB(420,440);
//                mob.init();
//                
//                gui.addChild(mob);
//            }
            gui.addChild(continueBt);

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
            story.bitmapData.dispose();
            ToolKit.mainLevel.removeChild(gui);
            var l : int = ToolKit.popupLevel.numChildren;
            while(--l -(-1))
            {
                ToolKit.popupLevel.removeChild(ToolKit.popupLevel.getChildAt(l));
            } 
            super.release ();
            SoundManagerInstance.stopSound('loop');
        }
    }
}
