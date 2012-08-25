package ludum.effects
{
    import flash.geom.Matrix;
    import abe.com.motion.Impulse;
    import abe.com.mon.logs.Log;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.motion.ImpulseListener;
    import abe.com.ponents.allocators.EmbeddedBitmapAllocatorInstance;

    import ludum.Constants;
    import ludum.assets.Misc;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;

    /**
     * @author cedric
     */
    public class MobSplash extends Sprite implements Allocable, ImpulseListener
    {
        private var spritesheet : Bitmap;
        private var spriteSplash : BitmapData;
        private var spriteDrops : BitmapData;
        private var splashBmp : Bitmap;
        private var dropsBmp : Bitmap;
        private var splashSprite : Sprite;
        private var dropsSprite : Sprite;
        private var _bitmap : BitmapData;
        private var _t : int;
        
        public function MobSplash (bitmap:BitmapData)
        {
            _bitmap = bitmap;
            init();
        }

        public function init () : void
        {
            spritesheet = EmbeddedBitmapAllocatorInstance.get(Misc.SPLATS) as Bitmap;
            Log.debug(spritesheet);
            spriteSplash = new BitmapData(Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT, true, 0);
            spriteDrops = new BitmapData(Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT, true, 0);
            var w : int = spritesheet.width / Constants.SPLATS_WIDTH;
            spriteSplash.copyPixels(spritesheet.bitmapData, rect(RandomUtils.irandom(w), Constants.SPLATS_HEIGHT, Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT), pt());
            spriteDrops.copyPixels(spritesheet.bitmapData, rect(RandomUtils.irandom(w), 0, Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT), pt());
                        
            splashBmp = new Bitmap(spriteSplash, 'auto', true);
            dropsBmp = new Bitmap(spriteDrops, 'auto', true);
            
            splashSprite = new Sprite();
            dropsSprite = new Sprite();
            
            splashBmp.x = -Constants.SPLATS_WIDTH/2;
            splashBmp.y = -Constants.SPLATS_HEIGHT/2;
            dropsBmp.x = -Constants.SPLATS_WIDTH/2;
            dropsBmp.y = -Constants.SPLATS_HEIGHT/2;
            
            splashSprite.addChild(splashBmp);
            dropsSprite.addChild(dropsBmp);
            
            splashSprite.scaleX = .5;
            splashSprite.scaleY = .5;
            splashSprite.rotation = RandomUtils.random(360);
            
            dropsSprite.scaleX = .5;
            dropsSprite.scaleY = .5;
            dropsSprite.rotation = RandomUtils.random(360);
            dropsSprite.alpha = 0;
            
            _t = 0;        
            
            addChild(splashSprite);  
            addChild(dropsSprite);  
            
            Impulse.register(tick);
        }

        public function dispose () : void
        {
            EmbeddedBitmapAllocatorInstance.release(spritesheet, Misc.SPLATS);
            spriteDrops.dispose();
            spriteSplash.dispose();
            removeChild(splashSprite);
            removeChild(dropsSprite);
            Impulse.unregister(tick);
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            x -= Constants.SCROLL_RATE * biasInSeconds;
            
            if( _t < 250 )
            {
                splashSprite.scaleX = splashSprite.scaleY = 0.5 + ((_t/250) * (_t/250))*2;             
            }
            if( _t > 100 && _t < 350 )
            {
                dropsSprite.alpha = 1;
                dropsSprite.scaleX = dropsSprite.scaleY = 0.5 + (((_t-100)/250) * ((_t-100)/250))*2;             
            }
            if( _t > 350 )
            {
                var m:Matrix = new Matrix();
                m.translate(x, y); 
                _bitmap.draw(this, m);
                parent.removeChild(this);
                dispose();
            }
            _t += bias;
        }
    }
}
