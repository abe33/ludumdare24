package ludum.states
{
    import abe.com.edia.commands.SimpleFadeIn;
    import abe.com.edia.commands.SimpleFadeOut;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;
    import abe.com.edia.text.fx.show.DefaultTimedDisplayEffect;
    import abe.com.mands.Command;
    import abe.com.mands.Queue;
    import abe.com.mon.colors.Color;
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.utils.ToolKit;

    import ludum.Constants;
    import ludum.assets.Misc;
    import ludum.assets.UIButton;
    import ludum.effects.ShowMessage;

    import flash.display.Bitmap;
    import flash.filters.DropShadowFilter;
    import flash.utils.setTimeout;

    /**
     * @author cedric
     */
    public class StoryState extends AbstractUIState
    {
        private var queue : Queue;
        private var skip : Button;
        private var story : Bitmap;
        public function StoryState ()
        {
            super ();
        }

        override public function activate ( previousState : UIState ) : void
        {
            super.activate ( previousState );
            DefaultTimedDisplayEffect, DropShadowFilter;
            new SimpleFadeIn(ToolKit.popupLevel, Color.Black).execute();
            skip = new UIButton("<b>SKIP</b>");
            skip.x = Constants.WIDTH - skip.width - 5;
            skip.y = Constants.HEIGHT - skip.height - 5;
            skip.actionTriggered.add(cancel);
            skip.preferredWidth = 220;
            skip.rotationZ = -45;       
            skip.x = Constants.WIDTH-125;
            skip.y = Constants.HEIGHT +25;
            
            story = new Misc.STORY() as Bitmap;
            
            ToolKit.popupLevel.addChild(story);
            ToolKit.popupLevel.addChild(skip);
            
            queue = new Queue();
                        
            queue.addCommand(
            	new ShowMessage(
                	formatMessage(
                    	" Ah! My trusted assistants!"), 2500, Constants.HEIGHT - 150));
             
            queue.addCommand(
            	new ShowMessage(
                	formatMessage(
                    	"A new planet is born.\nIt's up to you to decide whether it's gonna\nbe a nice or a bad one."), 5000, Constants.HEIGHT - 150)); 
            
            queue.addCommand(
            	new ShowMessage(
                	formatMessage(
                    	"Go, my loyal fellows,\nand try to keep the balance!"), 4500, Constants.HEIGHT - 150));
            
            queue.commandEnded.add(go);
            
            setTimeout(function():void{
	            queue.execute();                        
            }, 500);           
        }
        
        private function go(c:Command=null):void
        {
            new SimpleFadeOut(ToolKit.popupLevel, Color.Black).execute();
            SoundManagerInstance.fadeSound('loop', 0, 500);
            setTimeout(function():void{
	            var l : int = ToolKit.popupLevel.numChildren;
	            while(--l -(-1))
	            {
	                ToolKit.popupLevel.removeChild(ToolKit.popupLevel.getChildAt(l));
	            } 
	            _manager.goto("play"); 
            }, 500);
            
        }

        private function cancel (... args) : void
        {
            queue.cancel();
            go();
        }
        public function formatMessage(msg : String):String
        {
            return "<fx:effect type='new abe.com.edia.text.fx.show::DefaultTimedDisplayEffect(20)'>"+
	            	"<fx:filter type='new flash.filters::DropShadowFilter(0,0,0,1,4,4,2)'>"+
	                	"<p align='center'>" +
	                    	"<font color='0xffffff' size='24' face='Diogenes' embedFonts='true'>"+
				                msg + 
	                        "</font>" +
	                    "</p>" +
	                "</fx:filter>"+
                "</fx:effect>";
        }

        override public function release () : void
        {
            super.release ();
            story.bitmapData.dispose();
            skip.actionTriggered.remove(cancel);
            SoundManagerInstance.stopSound('loop');
        }
    }
}
