package ludum.game
{
    import ludum.assets.BlackSkin;
    import ludum.assets.WhiteSkin;
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.core.Suspendable;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;

    import flash.display.Shape;
    import flash.display.Sprite;

    /**
     * @author cedric
     */
    public class GameBoard extends Sprite implements Allocable, ImpulseListener, Suspendable
    {
        protected var _running : Boolean;
        
        public var boardMask : Mask;
        public var player : Player;
        public var maskShape : Shape;
        
        public var whiteLand:Land;
        public var blackLand:Land;
        
        public function GameBoard (player: Player)
        {
         	this.player = player;
        }

        public function init () : void
        {
            boardMask = new Mask(); 
            maskShape = new Shape();
            
            whiteLand = new Land(WhiteSkin);
            blackLand = new Land(BlackSkin);
            
            whiteLand.init();
            blackLand.init();
            
            addChild(whiteLand);
            addChild(blackLand);
            blackLand.mask = maskShape;
        }

        public function dispose () : void
        {
            boardMask = null;
            maskShape = null;
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
//            boardMask.ratio = player.ratio;
            boardMask.ratio = Math.sin(currentTime/10000 % Math.PI*2);
            
            boardMask.update(bias, biasInSeconds);
            whiteLand.update(bias, biasInSeconds);
            blackLand.update(bias, biasInSeconds);
            
            boardMask.draw(maskShape);
        }

        public function start () : void
        {
            if(!_running)
            {
            	Impulse.register(tick);
                _running = true;
            }
        }

        public function stop () : void
        {
            if(_running)
            {
	            Impulse.unregister(tick);
    			_running = false;            
            }
        }

        public function isRunning () : Boolean
        {
            return _running; 
        }
    }
}
