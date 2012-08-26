package ludum.game
{
    import abe.com.edia.particles.display.discShape;
    import abe.com.edia.particles.actions.AlphaLifeTweenActionStrategy;
    import abe.com.edia.particles.actions.FrictionActionStrategy;
    import abe.com.edia.particles.actions.LifeActionStrategy;
    import abe.com.edia.particles.actions.MacroActionStrategy;
    import abe.com.edia.particles.actions.MoveActionStrategy;
    import abe.com.edia.particles.actions.ScaleLifeTweenActionStrategy;
    import abe.com.edia.particles.complex.VelocitySpitter;
    import abe.com.edia.particles.core.BaseParticleSystem;
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.display.blurryDotFromGradient;
    import abe.com.edia.particles.emissions.Emission;
    import abe.com.edia.particles.initializers.DisplayObjectInitializer;
    import abe.com.edia.particles.initializers.LifeInitializer;
    import abe.com.edia.particles.initializers.MacroInitializer;
    import abe.com.edia.particles.initializers.RandomizePositionInitializer;
    import abe.com.edia.particles.initializers.RandomizeVelocityInitializer;
    import abe.com.edia.particles.timers.InfiniteTimer;
    import abe.com.mon.colors.Color;
    import abe.com.mon.colors.Gradient;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.core.Suspendable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;
    import abe.com.mon.geom.tmpPt;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.motion.easing.Quad;
    import abe.com.ponents.utils.ToolKit;

    import ludum.Constants;
    import ludum.assets.BlackSkin;
    import ludum.assets.WhiteSkin;
    import ludum.effects.BitmapScroller;
    import ludum.effects.MobSplash;
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
        private var system : BaseParticleSystem;
        private var particleLevel : Sprite;
        
        public function GameBoard () {}

        public function init () : void
        {
            scrollRect = rect(0,0,Constants.WIDTH, Constants.HEIGHT);
            
            boardMask = new Mask(); 
            maskShape = new Shape();
            playerLevel = new Sprite();
            mobLevel = new Sprite();
            particleLevel = new Sprite();
            
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
            
            player.controller.bitmap = playerTrailBitmap;
                        
            var shader: Shader = new Shader(new SHADER() as ByteArray);
            playerLevel.blendShader = shader;
            playerLevel.blendMode = "shader";
            
            addChild(whiteLand);
            addChild(blackLand);
            blackLand.mask = maskShape;
            addChild(mobLevel);
            addChild(playerLevel);
            playerLevel.addChild(new Bitmap(playerTrailBitmap));
            playerLevel.addChild(particleLevel);
            playerLevel.addChild(player);
            
            initParticles();
        }

        private function initParticles () : void
        {
            var v : VelocitySpitter = new VelocitySpitter( player, 150, 0.001, .5 );
            
            system = new BaseParticleSystem( 
            	new MacroInitializer(
                	new DisplayObjectInitializer(discShape(3, Color.Black), particleLevel),
                    new LifeInitializer(500, 1500),
                    new RandomizePositionInitializer(),
                    v,
                    new RandomizeVelocityInitializer(Math.PI/6,10)
                ),
            	new MacroActionStrategy(
                	new LifeActionStrategy(),
                    new MoveActionStrategy(),
                    new FrictionActionStrategy(),
                    new ScaleLifeTweenActionStrategy(pt(1,1), pt(0.2,0.2), Quad.easeOut)
                ) 
            );
            
            
            var emission : Emission = new Emission(
	            	DisplayObjectParticle, v, new InfiniteTimer(), v
            );
            system.emit(emission ); 
        }

        public function dispose () : void
        {
            boardMask = null;
            maskShape = null;
            system.stop();
            system.dispose();
            player.dispose();
            whiteLand.dispose();
            blackLand.dispose();
            playerTrailBitmap.dispose();
            playerTrail.dispose();
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
	        boardMask.ratio = player.ratio/player.total;
            
            boardMask.update(bias, biasInSeconds);
            whiteLand.update(bias, biasInSeconds);
            blackLand.update(bias, biasInSeconds);
            playerTrailScroller.scroll(biasInSeconds);
            playerTrail.scroll(biasInSeconds);
            playerTrail.update(bias, biasInSeconds);
            player.update(bias, biasInSeconds);
            spawner.update(bias, biasInSeconds);
            
            var scrollAmount: Number = Constants.SCROLL_RATE * biasInSeconds;
            
            var a : Array = spawner.allMobs.concat();
            for each(var mob:Mob in a)
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
                if(mob is WhiteMob)
                	player.whiteAmount++;
                else 
                	player.blackAmount++;
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
