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

    /**
     * @author cedric
     */
    public class BurstSplash extends Sprite implements Allocable, ImpulseListener
    {
        private var spritesheet : Bitmap;
        private var spriteSplash : BitmapData;
        private var splashBmp : Bitmap;
        private var splashSprite : Sprite;
        private var _t : int;
        private var _bitmap : BitmapData;

        public function BurstSplash ( bitmap : BitmapData )
        {
            init();
            _bitmap = bitmap;
        }

        public function init () : void
        {
            Impulse.register(tick);
            spritesheet = EmbeddedBitmapAllocatorInstance.get(Misc.SPLATS) as Bitmap;
            spriteSplash = new BitmapData(Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT, true, 0);
            var w : int = spritesheet.bitmapData.width / Constants.SPLATS_WIDTH;
            spriteSplash.copyPixels(spritesheet.bitmapData, rect(RandomUtils.irandom(w)*Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT*2, Constants.SPLATS_WIDTH, Constants.SPLATS_HEIGHT), pt());
                        
            splashBmp = new Bitmap(spriteSplash, 'auto', true);
            
            splashSprite = new Sprite();
            splashBmp.x = -Constants.SPLATS_WIDTH;
            splashBmp.y = -Constants.SPLATS_HEIGHT/2;
            
            splashSprite.addChild(splashBmp);
            
            splashSprite.scaleX = .1;
            splashSprite.scaleY = .1;
            
            _t = 0;        
            
            addChild(splashSprite);  
        }

        public function dispose () : void
        {
            if(!contains(splashSprite)) return;
            
            EmbeddedBitmapAllocatorInstance.release(spritesheet, Misc.SPLATS);
            Impulse.unregister(tick);
            spriteSplash.dispose();
            removeChild(splashSprite);
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            x -= Constants.SCROLL_RATE * biasInSeconds;
            
            if( _t < 100 )
            {
                splashSprite.scaleX = splashSprite.scaleY = 0.1 + ((_t/100) * (_t/100))*0.9;             
            }
            if( _t > 125 )
            {
                _bitmap.draw(this, this.transform.matrix);
                parent.removeChild(this);
                dispose();
            }
            _t += bias;            
        }
    }
}
