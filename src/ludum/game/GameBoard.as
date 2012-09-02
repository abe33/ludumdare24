package ludum.game
{
    import abe.com.edia.particles.actions.ContactWithSurfaceDeathActionStrategy;
    import abe.com.edia.particles.actions.ForceActionStrategy;
    import abe.com.edia.particles.actions.FrictionActionStrategy;
    import abe.com.edia.particles.actions.LifeActionStrategy;
    import abe.com.edia.particles.actions.MacroActionStrategy;
    import abe.com.edia.particles.actions.MoveActionStrategy;
    import abe.com.edia.particles.actions.RotateActionStrategy;
    import abe.com.edia.particles.actions.ScaleLifeTweenActionStrategy;
    import abe.com.edia.particles.complex.VelocitySpitter;
    import abe.com.edia.particles.core.BaseParticleSystem;
    import abe.com.edia.particles.core.DisplayObjectParticle;
    import abe.com.edia.particles.core.Particle;
    import abe.com.edia.particles.counters.ByRateCounter;
    import abe.com.edia.particles.counters.FixedCounter;
    import abe.com.edia.particles.display.discShape;
    import abe.com.edia.particles.display.squareShape;
    import abe.com.edia.particles.emissions.Emission;
    import abe.com.edia.particles.emitters.PathEmitter;
    import abe.com.edia.particles.emitters.PointEmitter;
    import abe.com.edia.particles.initializers.DisplayObjectInitializer;
    import abe.com.edia.particles.initializers.ExplosionInitializer;
    import abe.com.edia.particles.initializers.LifeInitializer;
    import abe.com.edia.particles.initializers.MacroInitializer;
    import abe.com.edia.particles.initializers.ParasiteInitializer;
    import abe.com.edia.particles.initializers.RandomizePositionInitializer;
    import abe.com.edia.particles.initializers.RandomizeVelocityInitializer;
    import abe.com.edia.particles.initializers.StreamInitializer;
    import abe.com.edia.particles.timers.InfiniteTimer;
    import abe.com.edia.particles.timers.InstantTimer;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.text.fx.show.DefaultTimedDisplayEffect;
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.core.Suspendable;
    import abe.com.mon.geom.LinearSpline;
    import abe.com.mon.geom.Rectangle2;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;
    import abe.com.mon.geom.tmpPt;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.motion.SingleTween;
    import abe.com.motion.easing.Cubic;
    import abe.com.motion.easing.Quad;

    import ludum.Constants;
    import ludum.assets.BlackSkin;
    import ludum.assets.Misc;
    import ludum.assets.WhiteSkin;
    import ludum.effects.BitmapScroller;
    import ludum.effects.MobSplash;
    import ludum.effects.ShowMessage;
    import ludum.effects.Tracer;

    import org.osflash.signals.Signal;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Shader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.filters.BlurFilter;
    import flash.filters.DropShadowFilter;
    import flash.geom.Point;
    import flash.utils.ByteArray;
    import flash.utils.setTimeout;

    /**
     * @author cedric
     */
    public class GameBoard extends Sprite implements Allocable, ImpulseListener, Suspendable
    {
        [Embed(source='../shaders/invert.pbj', mimeType="application/octet-stream")]
        private var SHADER:Class; 
        
        static public const Blue: Color = new Color("#2FB1D1"); 
        static public const Red: Color = new Color("#D13D2F"); 
        
        protected var _running : Boolean;
        protected var _t:Number;
        
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
        private var playerSystem : BaseParticleSystem;
        private var particleLevel : Sprite;
        private var mobParts : BaseParticleSystem;
        private var dustSystem : BaseParticleSystem;
        private var balance : MovieClip;
        private var effectsLevel : Sprite;
        public var gameEnded : Signal;
        private var _splashes : Array;
        private var progress : Sprite;
        private var _canInteract : Boolean;
        
        public function GameBoard () {
            gameEnded = new Signal();
        }

        public function init () : void
        {
            scrollRect = rect(0,0,Constants.WIDTH, Constants.HEIGHT);
            
            _t = 0;
            boardMask = new Mask(); 
            maskShape = new Shape();
            playerLevel = new Sprite();
            mobLevel = new Sprite();
            particleLevel = new Sprite();
            effectsLevel = new Sprite();
            balance = new Misc.BALANCE() as MovieClip;
            progress = new Misc.PROGRESS_BAR() as Sprite;
				
            _splashes = [];
            
            progress.x = Constants.WIDTH / 2;
            progress.y = Constants.HEIGHT;
            progress['_prog'].scaleX = 0.001;            
            
            balance.gotoAndStop(50);
            balance.x = Constants.WIDTH / 2;
            balance.scaleX = balance.scaleY = .4; 
            balance.y = Constants.HEIGHT-8;
            
            player = new Player();            
            whiteLand = new Land(WhiteSkin);
            blackLand = new Land(BlackSkin);
            playerTrailBitmap = new BitmapData(Constants.WIDTH+150, Constants.HEIGHT, true, 0x00000000);
            playerTrailScroller = new BitmapScroller(playerTrailBitmap);
            playerTrail = new Tracer(player, playerTrailBitmap);
            spawner = new Spawner(mobLevel, boardMask);
            
            player.x = -20;
            player.y = 240;
            
            spawner.init();
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
            addChild(effectsLevel);
            addChild(progress);
            addChild(balance);
            playerLevel.addChild(new Bitmap(playerTrailBitmap));
            playerLevel.addChild(particleLevel);
            playerLevel.addChild(player);
            
            initParticles();
                        
//            SoundManagerInstance.playSound("music", 0.5, 0, -1);
            
            DefaultTimedDisplayEffect, DropShadowFilter;
             
            new ShowMessage(
            	"<fx:effect type='new abe.com.edia.text.fx.show::DefaultTimedDisplayEffect(20)'>"+
	            	"<fx:filter type='new flash.filters::DropShadowFilter(0,0,0,1,4,4,2)'>"+
	                	"<p align='center'>" +
	                    	"<font color='0xffffff' size='24' face='Diogenes' embedFonts='true'>"+
				                "This is your new mission.\n"+
                                "Don't mess things up this time, try to keep the balance!"+
	                        "</font>" +
	                    "</p>" +
	                "</fx:filter>"+
                "</fx:effect>", 2500).execute();
            
            setTimeout(activatePlay, 3500);
            setTimeout(function():void{
                new SingleTween(player, "x", Constants.WIDTH/2, 1000, NaN, Cubic.easeOut).execute();
            }, 2500);
            
            
        }

       

        private function activatePlay () : void
        {
            _canInteract = true;
            setTimeout(endGame, Constants.GAME_DURATION);
        }

        private function endGame () : void
        {
            spawner.stop();
            
            DefaultTimedDisplayEffect, DropShadowFilter;
            
            new ShowMessage(
            	"<fx:effect type='new abe.com.edia.text.fx.show::DefaultTimedDisplayEffect(20)'>"+
	            	"<fx:filter type='new flash.filters::DropShadowFilter(0,0,0,1,4,4,2)'>"+
	                	"<p align='center'>" +
	                    	"<font color='0xffffff' size='24' face='Diogenes' embedFonts='true'>"+
				                "Congratulations!\nYour work on this world is now complete."+
	                        "</font>" +
	                    "</p>" +
	                "</fx:filter>"+
                "</fx:effect>", 3000).execute();
            
            setTimeout(function():void {
	            gameEnded.dispatch(this);
            }, Constants.END_GAME_GAP);
        }

        private function initParticles () : void
        {
            var v : VelocitySpitter = new VelocitySpitter( player, 150, 0.001, 1 );
            playerSystem = new BaseParticleSystem( 
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
                    new FrictionActionStrategy(.93),
                    new ScaleLifeTweenActionStrategy(pt(1,1), pt(0.2,0.2), Quad.easeOut)
                ) 
            );
            mobParts = new BaseParticleSystem( 
            	new MacroInitializer(
                	new DisplayObjectInitializer(function(p:Particle):MovieClip{
                        var mc : MovieClip = new Misc.MOB_PARTICLES() as MovieClip;
                        var isGood: Boolean = p.getParasite('mob');
                        var c : Color = isGood ? Blue : Red;
                        mc.gotoAndStop((isGood ? 1 : 5) + RandomUtils.irandom(4));
                        mc.transform.colorTransform = c.toColorTransform(1);
                        mc.rotation = RandomUtils.irandom(360);
                        return mc;
                    }, effectsLevel),
                    new LifeInitializer(500, 1500),
                    new RandomizePositionInitializer(),
                    new ExplosionInitializer(200, 300),
                    new RandomizeVelocityInitializer(Math.PI/6,10)
                ),
            	new MacroActionStrategy(
                	new LifeActionStrategy(),
                    new MoveActionStrategy(),
                    new ForceActionStrategy(pt(-Constants.SCROLL_RATE*4,0)),
                    new RotateActionStrategy(-180, 180),
                    new FrictionActionStrategy(.93),
                    new ScaleLifeTweenActionStrategy(pt(1,1), pt(0.2,0.2), Quad.easeOut)
                ) 
            );
            dustSystem = new BaseParticleSystem(
            	new MacroInitializer(
                	new DisplayObjectInitializer(function(p:Particle):Shape{
                        var s: Shape = squareShape(RandomUtils.irangeAB(10,30),1, Color.Black.alphaClone(0xcc))(p);
                        s.filters = [new BlurFilter(RandomUtils.irangeAB(3,6), 3)];
                        return s;
                    }, particleLevel),
                    new StreamInitializer(pt(-Constants.SCROLL_RATE*8), 10)                    
                ),
                new MacroActionStrategy(
                	new MoveActionStrategy(),
                    new ContactWithSurfaceDeathActionStrategy(new Rectangle2(-50,0,50,Constants.HEIGHT))
                )
            );
            
            
            var emission : Emission = new Emission(
	            DisplayObjectParticle, v, new InfiniteTimer(), v
            );
            playerSystem.emit(emission); 
            
            emission = new Emission(
	            DisplayObjectParticle, 
                new PathEmitter(new LinearSpline([pt(Constants.WIDTH + 50, 0), pt(Constants.WIDTH+50, Constants.HEIGHT)])), 
                new InfiniteTimer(),
                new ByRateCounter(8)
            );
            dustSystem.emit(emission); 
        } 

        public function dispose () : void
        {
            Impulse.unregister(tick);
            playerSystem.stop();
            playerSystem.dispose();
            player.dispose();
            whiteLand.dispose();
            blackLand.dispose();
            playerTrail.dispose();
            playerTrailBitmap.dispose();
            mobParts.stop();
            mobParts.dispose();
            dustSystem.stop();
            dustSystem.dispose();
            spawner.dispose();
                        
            for each(var s:MobSplash in _splashes)
            	s.dispose();
            
            boardMask = null;
            maskShape = null;
            
            SoundManagerInstance.stopSound('music');
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
	        boardMask.ratio = player.ratio/(player.total || 1);
            
            boardMask.update(bias, biasInSeconds);
            whiteLand.update(bias, biasInSeconds);
            blackLand.update(bias, biasInSeconds);
            playerTrailScroller.scroll(biasInSeconds);
            playerTrail.scroll(biasInSeconds);
            playerTrail.update(bias, biasInSeconds);
            
            if(_canInteract)
            {
	            player.update(bias, biasInSeconds);
	            spawner.update(bias, biasInSeconds);
	                        
	            var scrollAmount: Number = Constants.SCROLL_RATE * biasInSeconds;
	            
	            var a:Array = spawner.allMobs.concat();
	            for each(var mob:Mob in a)
	            {
	                mob.update(bias, biasInSeconds);
	                mob.x -= scrollAmount;
	                solveCollision(mob);
	                                
	                if( mob.x < Constants.SPAWN_OUT )
	                	spawner.release(mob);
	            }
	            progress['_prog'].scaleX = Math.min(_t/Constants.GAME_DURATION, 1);            
	            _t += bias;
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
                
                _splashes.push(splash);
                
                var emission : Emission = new Emission(
	            	DisplayObjectParticle, 
                    new PointEmitter(pt(mob.x, mob.y)), 
                    new InstantTimer(), 
                    new FixedCounter(RandomUtils.irangeAB(8, 16)),
                    new ParasiteInitializer('mob', mob is WhiteMob)
	            );
                
                var xplosion: MobExplode = new MobExplode(effectsLevel, mob);
                var absorb: MobAbsorb = new MobAbsorb(balance, mob);
                if(mob is WhiteMob)
                {
	                absorb.view.x =  balance['_bad'].x;                   
	                absorb.view.y =  balance['_bad'].y;                   
                }
                else
                {
                    absorb.view.x =  balance['_good'].x;                   
	                absorb.view.y =  balance['_good'].y;  
                }
                
	            mobParts.emit(emission);
                
            	spawner.release(mob);
                
                if(mob is WhiteMob)
                	player.whiteAmount++;
                else 
                	player.blackAmount++;
                  
                balance.gotoAndStop(50 - Math.max(-50, Math.min(50, player.ratio*2)));
                
//                SoundManagerInstance.playSound("swoosh", 0.7, 0, 0);
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
