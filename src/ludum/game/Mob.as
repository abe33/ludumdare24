package ludum.game
{
    import flash.display.PixelSnapping;
    import abe.com.mon.logs.Log;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;
    import abe.com.mon.utils.RandomUtils;

    import ludum.Constants;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;

    /**
     * @author cedric
     */
    public class Mob extends Sprite implements Allocable
    {
        public var SKIN : Object;
        private var spritesheet : BitmapData;
        private var sprite : BitmapData;
        private var bmp : Bitmap;
        
        public function Mob ()
        {
        }

        public function init () : void
        {
            spritesheet = (new SKIN.MOB_SPRITESHEET()as Bitmap).bitmapData;
                        
            var w: Number = spritesheet.width / Constants.MOB_SPRITE_WIDTH;
            var h: Number = spritesheet.height / Constants.MOB_SPRITE_HEIGHT;
            sprite = new BitmapData(Constants.MOB_SPRITE_WIDTH,Constants.MOB_SPRITE_HEIGHT, true, 0);
            
            sprite.copyPixels(spritesheet, rect(RandomUtils.irandom(w),RandomUtils.irandom(h),Constants.MOB_SPRITE_WIDTH,Constants.MOB_SPRITE_HEIGHT), pt());
            
            bmp = new Bitmap(sprite,PixelSnapping.AUTO, true);
            bmp.x = -Constants.MOB_SPRITE_WIDTH/2;
            bmp.y = -Constants.MOB_SPRITE_HEIGHT/2;
            addChild(bmp);
        }

        public function dispose () : void
        {
            removeChild(bmp);
            spritesheet.dispose();
            sprite.dispose();
            
            spritesheet = null;
            sprite = null;
        }
    }
}
