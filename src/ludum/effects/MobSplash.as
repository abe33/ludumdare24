package ludum.effects
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.ponents.allocators.EmbeddedBitmapAllocatorInstance;

    import ludum.Constants;
    import ludum.assets.Misc;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;

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
            spriteSplash = new BitmapData(Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT, true, 0);
            spriteDrops = new BitmapData(Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT, true, 0);
            var w : int = spritesheet.bitmapData.width / Constants.SPLATS_WIDTH;
            spriteSplash.copyPixels(spritesheet.bitmapData, rect(RandomUtils.irandom(w)*Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT, Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT), pt());
            spriteDrops.copyPixels(spritesheet.bitmapData, rect(RandomUtils.irandom(w)*Constants.SPLATS_WIDTH, 0, Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT), pt());
                        
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
            
            splashSprite.scaleX = .1;
            splashSprite.scaleY = .1;
            splashSprite.rotation = RandomUtils.random(360);
            
            dropsSprite.scaleX = .1;
            dropsSprite.scaleY = .1;
            dropsSprite.rotation = RandomUtils.random(360);
            dropsSprite.alpha = 0;
            
            _t = 0;        
            
            addChild(splashSprite);  
            addChild(dropsSprite);  
            
            Impulse.register(tick);
        }

        public function dispose () : void
        {
            if(!contains(splashSprite)) return;
            
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
            
            if( _t < 100 )
            {
                splashSprite.scaleX = splashSprite.scaleY = 0.1 + ((_t/100) * (_t/100))*0.9;             
            }
            if( _t > 25 && _t < 125 )
            {
                dropsSprite.alpha = 1;
                dropsSprite.scaleX = dropsSprite.scaleY = 0.1 + (((_t-25)/100) * ((_t-25)/100))*0.9;             
            }
            if( _t > 125 )
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
