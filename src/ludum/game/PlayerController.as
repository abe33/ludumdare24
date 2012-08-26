package ludum.game
{
    import flash.display.BitmapData;
    import ludum.effects.BurstSplash;
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
        private var _bitmap : BitmapData;
        private var _burstTime : Number;
        
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
             /*   
            if(mouse.x > Constants.MOUSE_LIMIT && mouse.x < Constants.WIDTH - Constants.MOUSE_LIMIT && 
               mouse.y > Constants.MOUSE_LIMIT && mouse.y < Constants.HEIGHT - Constants.MOUSE_LIMIT)
            {*/
	            if(dif.length > Constants.MAX_DISTANCE && !_burst) dif.normalize(Constants.MAX_DISTANCE);
	                        
	            velocity.x += dif.x / Constants.MOTION_SMOOTHNESS;
	            velocity.y += dif.y / Constants.MOTION_SMOOTHNESS;
	
	            var angle: Number = MathUtils.rad2deg(Math.atan2(velocity.y, velocity.x));
	            
	            rotation = angle;          
            //}
            
            if(_burst)
            {
                _burstTime += bias;
                if( _burstTime > Constants.BURST_TIMEOUT )
                	_burst = false;
            }
            
		    player.x += velocity.x * biasInSeconds;
		    player.y += velocity.y * biasInSeconds;                
            
            velocity.x *= Constants.FRICTION;
            velocity.y *= Constants.FRICTION;
            
            if(player.ratio > Constants.PLAYER_STATE_SWITCH)
            	player.view.gotoAndStop(3);
            else if(player.ratio < -Constants.PLAYER_STATE_SWITCH)
            	player.view.gotoAndStop(1);
            else
            	player.view.gotoAndStop(2);
            
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
//            _burst = false;
        }

        private function mouseDown ( event : MouseEvent ) : void
        {
            var mouse : Point = pt(StageUtils.stage.mouseX,StageUtils.stage.mouseY);
            _burst = true;
            _burstTime = 0;
            
            velocity = mouse.subtract(pt(player.x, player.y));
            velocity.normalize(Constants.BURST_SPEED);
            
            var splash: BurstSplash = new BurstSplash (_bitmap );
            splash.x = player.x;
            splash.y = player.y;
            splash.rotation = player.view['_hero']['_body'].rotation;
            player.parent.addChildAt(splash, 0);
        }

        public function get bitmap () : BitmapData {
            return _bitmap;
        }

        public function set bitmap ( bitmap : BitmapData ) : void {
            _bitmap = bitmap;
        }
    }
}