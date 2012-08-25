package ludum.game
{
    import abe.com.mon.core.Allocable;

    import flash.display.MovieClip;
    import flash.display.Sprite;
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
        }
        
        public function get ratio () : Number {
            return 0;
        }

        public function init () : void
        {
            whiteAmount = 1;
            blackAmount = 1;
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
