package ludum.effects
{
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;

    import ludum.Constants;

    import flash.display.BitmapData;
    /**
     * @author cedric
     */
    public class BitmapScroller
    {
        private var bitmap : BitmapData;
        public function BitmapScroller (bmp:BitmapData)
        {
            bitmap = bmp;
        }
        public function scroll(bias:Number) : void
        {
            var amount: Number = Math.floor(Constants.SCROLL_RATE * bias);
            var pos : Number = bitmap.width - amount;
	        bitmap.copyPixels(bitmap, rect(amount, 0, pos, Constants.HEIGHT), pt());        
	        bitmap.fillRect(rect(pos, 0, amount, Constants.HEIGHT), 0x00000000);        
        }
    }
}
