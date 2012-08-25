package ludum.game
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.MathUtils;
    import abe.com.mon.utils.StageUtils;

    import ludum.Constants;

    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.ui.Mouse;
    /**
     * @author cedric
     */
    public class PlayerController implements Allocable
    {
        public var velocity : Point;
        public var rotationVelocity : Number;
        public var player : Player;
        public var rotation : Number;
        private var _burst : Boolean;
        
        public function PlayerController (player: Player)
        {
            this.player = player;
        }
        
        public function update(bias:Number, biasInSeconds:Number):void
        {
            var mouse : Point = pt(StageUtils.stage.mouseX,StageUtils.stage.mouseY);
            
            var dif : Point = mouse.subtract(pt(player.x, player.y));
            
            if(dif.length < Constants.MOUSE_PROXIMITY)
            	Mouse.hide();
			else
            	Mouse.show();
                
            if(mouse.x > Constants.MOUSE_LIMIT && mouse.x < Constants.WIDTH - Constants.MOUSE_LIMIT && 
               mouse.y > Constants.MOUSE_LIMIT && mouse.y < Constants.HEIGHT - Constants.MOUSE_LIMIT)
            {
	            if(dif.length > Constants.MAX_DISTANCE && !_burst) dif.normalize(Constants.MAX_DISTANCE);
	                        
	            velocity.x += dif.x / Constants.MOTION_SMOOTHNESS;
	            velocity.y += dif.y / Constants.MOTION_SMOOTHNESS;
	
	            var angle: Number = MathUtils.rad2deg(Math.atan2(velocity.y, velocity.x));
	            
	            rotation = angle;          
            }
		    player.x += velocity.x * biasInSeconds;
		    player.y += velocity.y * biasInSeconds;                
            
            velocity.x *= Constants.FRICTION;
            velocity.y *= Constants.FRICTION;
        }

        public function init () : void
        {
            rotation = 0;
            velocity = new Point();
            StageUtils.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            StageUtils.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUP);
        }

        public function dispose () : void
        {
            velocity = null;
            StageUtils.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            StageUtils.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUP);
        }
        
        private function mouseUP ( event : MouseEvent ) : void
        {
            _burst = false;
        }

        private function mouseDown ( event : MouseEvent ) : void
        {
            var mouse : Point = pt(StageUtils.stage.mouseX,StageUtils.stage.mouseY);
            _burst = true;
            
            velocity = mouse.subtract(pt(player.x, player.y));
            velocity.normalize(Constants.BURST_SPEED);
        }
    }
}