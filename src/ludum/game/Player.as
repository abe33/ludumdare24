package ludum.game
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.utils.StageUtils;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    /**
     * @author cedric
     */
    public class Player extends Sprite implements Allocable
    {
       
        [Embed(source='../../../assets/swf/gfx.swf', symbol='gfx.Hero')]
        public var SKIN:Class;
        
        public var whiteAmount: Number;
        public var blackAmount : Number;
        public var view : MovieClip;
        public var controller : PlayerController;

        public function Player ()
        {
            
            CONFIG::DEBUG
            {
             	StageUtils.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void{
                    var mc: MovieClip = view;
                    mc.gotoAndStop(mc.currentFrame + 1 <= mc.totalFrames ? mc.currentFrame + 1 : 1);
                });   
            }
        }
        
        public function get ratio () : Number {
            return blackAmount - whiteAmount;
        }
        public function get total () : Number {
            return whiteAmount + blackAmount;
        }

        public function init () : void
        {
            whiteAmount = 0;
            blackAmount = 0;
            controller = new PlayerController(this);
            controller.init();
            
            view = new SKIN() as MovieClip;
            view.stop();
            addChild(view);           
        }

        public function dispose () : void
        {
            controller.dispose();
            removeChild(view);
            view = null;
            controller = null;
        }

        public function update ( bias : Number, biasInSeconds : Number ) : void
        {
            controller.update(bias, biasInSeconds);
            
            var body :MovieClip = view["_hero"]["_body"];
            
            body.rotation = 0;
            body.scaleY = Math.min(1 + controller.velocity.length / 500, 1.5);
            body.scaleX = Math.min(1 + controller.velocity.length / 500, 1.5);
            body.rotation = controller.rotation;
        }

    }
}
