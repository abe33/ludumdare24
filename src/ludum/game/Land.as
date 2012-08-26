package ludum.game
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;
    import abe.com.mon.utils.RandomUtils;

    import ludum.Constants;
    import ludum.assets.BlackSkin;
    import ludum.assets.WhiteSkin;
    import ludum.effects.BitmapScroller;

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
        private var _scroller : BitmapScroller;
        private var _bgProps : BitmapData;
                
        public function Land (skin: Object)
        {
            _skin = skin;
        }
        
        public function update(bias:Number, biasInSeconds: Number):void
        {
             scrollBackground(biasInSeconds);
        }

        private function scrollBackground (bias:Number) : void
        {
            var amount: Number = Math.floor(Constants.SCROLL_RATE * bias);
            var pos : Number = Constants.WIDTH - amount;
	        _scroller.scroll(bias);
            
            if( _scrollAmount + amount >= Constants.BACKGROUND_TILE_WIDTH )
            {
                var dif:Number = _scrollAmount + amount - Constants.BACKGROUND_TILE_WIDTH;
                                
                _bitmapData.copyPixels(_tileBuffer, rect(_scrollAmount, 0, dif*2, Constants.HEIGHT), pt(pos));
            	prepareNextBackground();  
                _bitmapData.copyPixels(_tileBuffer, rect(0, 0, amount*2, Constants.HEIGHT), pt(pos));
                
                _scrollAmount = 0;
            }
            else
            {
                _bitmapData.copyPixels(_tileBuffer, rect(_scrollAmount, 0, amount, Constants.HEIGHT), pt(pos));
	            _scrollAmount += amount;                
            }            
        }

        private function prepareNextBackground () : void
        {
            for(var row:int = 0; row < 5; row++)
            {
             	var col:int = Math.floor(Math.random()*4);
                _tileBuffer.copyPixels(_bgSprite, 
                					   rect(col * Constants.BACKGROUND_TILE_WIDTH, 
                                       		row * Constants.BACKGROUND_TILE_HEIGHT, 
                                            Constants.BACKGROUND_TILE_WIDTH, 
                                            Constants.BACKGROUND_TILE_HEIGHT), 
                                       pt(0, row * Constants.BACKGROUND_TILE_HEIGHT));
            }
            if(RandomUtils.boolean())
            {
                row = RandomUtils.irangeAB(0, 1);
                col = RandomUtils.irandom(_bgProps.width / Constants.BACKGROUND_PROPS_WIDTH);
                if(row == 0)
                {
                    var y : Number = _skin == BlackSkin ? 70 : 0;
                    _tileBuffer.copyPixels(_bgProps, 
                    					   rect(col * Constants.BACKGROUND_PROPS_WIDTH, 
                                           		row * Constants.BACKGROUND_PROPS_HEIGHT,
                                                Constants.BACKGROUND_PROPS_WIDTH,
                                                Constants.BACKGROUND_PROPS_HEIGHT), 
                                           pt(RandomUtils.irandom(Constants.BACKGROUND_TILE_WIDTH-Constants.BACKGROUND_PROPS_WIDTH), y),
                                           null, null, true);
                }
                else
                {
                    y = _skin == WhiteSkin ? Constants.HEIGHT/2 - 70 : Constants.HEIGHT/2;
                    _tileBuffer.copyPixels(_bgProps, 
                    					   rect(col * Constants.BACKGROUND_PROPS_WIDTH, 
                                           		row * Constants.BACKGROUND_PROPS_HEIGHT,
                                                Constants.BACKGROUND_PROPS_WIDTH,
                                                Constants.BACKGROUND_PROPS_HEIGHT), 
                                           pt(RandomUtils.irandom(Constants.BACKGROUND_TILE_WIDTH-Constants.BACKGROUND_PROPS_WIDTH), y),
                                           null, null, true);
                }
            }
        }
        
        public function init () : void
        {
            _scrollAmount = 0;
            _bgSprite = (new _skin.BACKGROUND() as Bitmap).bitmapData;
            _bgProps = (new _skin.PROPS_SPRITESHEET() as Bitmap).bitmapData;
            _bitmapData = new BitmapData(Constants.WIDTH, Constants.HEIGHT);
   	        _tileBuffer = new BitmapData(Constants.BACKGROUND_TILE_WIDTH, Constants.BACKGROUND_TILE_HEIGHT * 5);
            
            prepareNextBackground();
            
            _bitmapData.copyPixels(_bgSprite, _bgSprite.rect, pt());
            _bitmap = new Bitmap(_bitmapData);
            addChild(_bitmap);

            _scroller = new BitmapScroller(_bitmapData);
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
