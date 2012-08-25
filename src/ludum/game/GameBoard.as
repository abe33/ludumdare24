package ludum.game
{
    import ludum.effects.MobSplash;
    import flash.ui.Mouse;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.core.Suspendable;
    import abe.com.mon.geom.rect;
    import abe.com.mon.geom.tmpPt;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;

    import ludum.Constants;
    import ludum.assets.BlackSkin;
    import ludum.assets.WhiteSkin;
    import ludum.effects.BitmapScroller;
    import ludum.effects.Tracer;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.utils.ByteArray;

    /**
     * @author cedric
     */
    public class GameBoard extends Sprite implements Allocable, ImpulseListener, Suspendable
    {
        [Embed(source='../shaders/invert.pbj', mimeType="application/octet-stream")]
        private var SHADER:Class; 
        
        
        protected var _running : Boolean;
        
        public var boardMask : Mask;
        public var player : Player;
        public var maskShape : Shape;
        
        public var whiteLand:Land;
        public var blackLand : Land;
        private var playerLevel : Sprite;
        private var playerTrail: Tracer;
        private var playerTrailBitmap: BitmapData;
        private var playerTrailScroller : BitmapScroller;
        private var mobLevel : Sprite;
        private var spawner : Spawner;
        
        public function GameBoard () {}

        public function init () : void
        {
            scrollRect = rect(0,0,Constants.WIDTH, Constants.HEIGHT);
            
            boardMask = new Mask(); 
            maskShape = new Shape();
            playerLevel = new Sprite();
            mobLevel = new Sprite();
            
            player = new Player();            
            whiteLand = new Land(WhiteSkin);
            blackLand = new Land(BlackSkin);
            playerTrailBitmap = new BitmapData(Constants.WIDTH, Constants.HEIGHT, true, 0x00000000);
            playerTrailScroller = new BitmapScroller(playerTrailBitmap);
            playerTrail = new Tracer(player, playerTrailBitmap);
            spawner = new Spawner(mobLevel, boardMask);
            
            player.x = 100;
            player.y = 240;
            
            player.init();
            playerTrail.init();
            whiteLand.init();
            blackLand.init();
                        
            var shader: Shader = new Shader(new SHADER() as ByteArray);
            playerLevel.blendShader = shader;
            playerLevel.blendMode = "shader";
            
            addChild(whiteLand);
            addChild(blackLand);
            blackLand.mask = maskShape;
            addChild(mobLevel);
            addChild(playerLevel);
            playerLevel.addChild(new Bitmap(playerTrailBitmap));
            playerLevel.addChild(player);
        }

        public function dispose () : void
        {
            boardMask = null;
            maskShape = null;
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            CONFIG::RELEASE
            {            
	            boardMask.ratio = player.ratio;
            }
            CONFIG::DEBUG
            {
	            boardMask.ratio = Math.sin(currentTime/10000 % Math.PI*2);            
            }
            
            boardMask.update(bias, biasInSeconds);
            whiteLand.update(bias, biasInSeconds);
            blackLand.update(bias, biasInSeconds);
            playerTrailScroller.scroll(biasInSeconds);
            playerTrail.scroll(biasInSeconds);
            playerTrail.update(bias, biasInSeconds);
            player.update(bias, biasInSeconds);
            spawner.update(bias, biasInSeconds);
            
            var scrollAmount: Number = Constants.SCROLL_RATE * biasInSeconds;
            
            for each(var mob:Mob in spawner.allMobs)
            {
                mob.x -= scrollAmount;
                solveCollision(mob);
                
                
                if( mob.x < Constants.SPAWN_OUT )
                	spawner.release(mob);
            }
                        
            boardMask.draw(maskShape);
        }

        private function solveCollision ( mob : Mob ) : void
        {
            var dist: Number = Point.distance(tmpPt(mob.x, mob.y), tmpPt(player.x, player.y));
            if(dist < Constants.COLLISION_DISTANCE)
            {
                var splash:MobSplash =new MobSplash(playerTrailBitmap);
                playerLevel.addChildAt(splash, 0);
                splash.x = mob.x;
                splash.y = mob.y;
            	spawner.release(mob);
            }
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
