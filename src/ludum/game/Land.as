package ludum.game
{
    import abe.com.mon.logs.Log;
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;

    import ludum.Constants;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;

    /**
     * @author cedric
     */
    public class Land extends Sprite implements Allocable
    {
        private var _bitmapData : BitmapData;
        private var _bgSprite : BitmapData;
        private var _skin : Object;
        private var _bitmap : Bitmap;
        private var _tileBuffer: BitmapData;
        private var _scrollAmount: Number;
                
        public function Land (skin: Object)
        {
            _skin = skin;
                                  
            CONFIG::DEBUG
            {
                this.graphics.moveTo(0, 0);
                this.graphics.lineTo(Constants.WIDTH, Constants.HEIGHT);
            }
        }
        
        public function update(bias:Number, biasInSeconds: Number):void
        {
             scrollBackground(biasInSeconds);
        }

        private function scrollBackground (bias:Number) : void
        {
            var amount: Number = Constants.SCROLL_RATE * bias;
            var pos : Number = _bitmapData.rect.width - amount;
	        _bitmapData.copyPixels(_bitmapData, rect(amount, 0, pos, _bitmapData.rect.height), pt());
            
            if( _scrollAmount + amount > Constants.BACKGROUND_TILE_WIDTH )
            {
                var dif:Number = Math.floor(_scrollAmount + amount - Constants.BACKGROUND_TILE_WIDTH);
                
                _bitmapData.copyPixels(_tileBuffer, rect(_scrollAmount, 0, dif, _bitmapData.rect.height), pt(pos));
            	prepareNextBackground();  
                _bitmapData.copyPixels(_tileBuffer, rect(0, 0, amount-dif, _bitmapData.rect.height), pt(pos+dif));
                
                _scrollAmount = dif;
            }
            else
            {
                _bitmapData.copyPixels(_tileBuffer, rect(_scrollAmount, 0, amount, _bitmapData.rect.height), pt(pos));
	            _scrollAmount += amount;                
            }            
        }

        private function prepareNextBackground () : void
        {
            for(var i:int = 0; i<4; i++)
            {
             	var col:int = Math.floor(Math.random()*4);
                _tileBuffer.copyPixels(_bgSprite, 
                					   rect(col*Constants.BACKGROUND_TILE_WIDTH, i*Constants.BACKGROUND_TILE_HEIGHT, Constants.BACKGROUND_TILE_WIDTH, Constants.BACKGROUND_TILE_HEIGHT), 
                                       pt(0, i * Constants.BACKGROUND_TILE_HEIGHT));
            }
        }
        
        public function init () : void
        {
            _scrollAmount = 0;
            _bgSprite = (new _skin.BACKGROUND() as Bitmap).bitmapData;
            _bitmapData = new BitmapData(Constants.WIDTH, Constants.HEIGHT);
   	        _tileBuffer = new BitmapData(Constants.BACKGROUND_TILE_WIDTH, Constants.BACKGROUND_TILE_HEIGHT * 4);
            
            prepareNextBackground();
            
            _bitmapData.copyPixels(_bgSprite, _bgSprite.rect, pt());
            _bitmap = new Bitmap(_bitmapData);
            addChild(_bitmap);
        }

        public function dispose () : void
        { 
            _bitmapData.dispose();
            _bgSprite.dispose();
            removeChild(_bitmap);
            _bitmap = null;
        }
    }
}
