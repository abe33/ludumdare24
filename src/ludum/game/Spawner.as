package ludum.game
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.geom.rect;
    import abe.com.mon.utils.MathUtils;
    import abe.com.mon.utils.RandomUtils;
    import abe.com.mon.utils.arrays.lastIn;
    import abe.com.ponents.utils.ToolKit;

    import ludum.Constants;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    /**
     * @author cedric
     */
    public class Spawner implements Allocable
    {
        [Embed(source='./patterns/test.png')]
        static public const SPAWN_MAP: Class;
        
        private var _container : Sprite;
        private var _t : int;
        private var _allMobs : Array;
        private var _mask : Mask;
        private var _quantity : Number;
        private var _factor : Number;
        private var _lock : Boolean;
        private var _spawnMap : Bitmap;
        private var _spawnCache : Array;
        private var _currentPattern: Array;
        
        private var _row : int;
        private var _x : int;
         
        public function Spawner ( container : Sprite, mask : Mask)
        {
           	_container = container;
            _mask = mask;
            _allMobs = [];
            _t = 0;
            _quantity = 1;
            _factor = 0.05;
            
        }
        public function init () : void
        {
            _row = 0;
            _spawnMap = new SPAWN_MAP() as Bitmap;
            _spawnCache = [];
            _x = 0;
            var bmp: BitmapData = _spawnMap.bitmapData
            var rows: int = bmp.height / Constants.SPAWN_ROW_HEIGHT;
            var lastX: int = 0;
            for(var i:int = 0; i<rows; i++)
            {
                _spawnCache[i] = [];
                var l : uint = bmp.width;
                var tmp:Array = [];
                for(var x:int = 0; x<l; x++)
                {
                    tmp.push(getPointsInColumn(x, i*Constants.SPAWN_ROW_HEIGHT));
                    var pix : uint = bmp.getPixel32(x, i*Constants.SPAWN_ROW_HEIGHT);
                    if(pix == 0xff000000) 
                    {
                        _spawnCache[i].push(tmp);
                        tmp = [];
                        lastX = x;
                    }
                }
            }
            _currentPattern = RandomUtils.inArray(_spawnCache[0]);
            
            CONFIG::DEBUG
            {
                ToolKit.popupLevel.addChild(_spawnMap);
                _spawnMap.x = Constants.WIDTH - _spawnMap.width;
            }
        }

        public function dispose () : void
        {
        }
        
        public function update(bias: Number, biasInSeconds:Number):void
        {
            if(_lock ) return;
            
            _t += bias;
            if( _t > Constants.SPAWN_SPEED) 
            {
                _x++;
                _t -= Constants.SPAWN_SPEED;
                
                if(_x >= _currentPattern.length)
                {
                	_x -= _currentPattern.length;
                    _currentPattern = RandomUtils.inArray(_spawnCache[0]);                    
                }
                
	            var last: Point = lastIn(_mask.curve.vertices);
				var points : Array = _currentPattern[_x];
	            for each(var p: Point in points)
	            {
	                var mob: Mob;
	                if(p.y < Constants.SPAWN_ROW_HEIGHT / 2)
	                {
	                    mob = new WhiteMob();
	                    mob.x = Constants.WIDTH + 100;
	                    mob.y = MathUtils.map(p.y, 0, Constants.SPAWN_ROW_HEIGHT/2, 0, last.y);
	                }
	                else
	                {
	                    mob = new BlackMob();
	                    mob.x = Constants.WIDTH + 100;
	                    mob.y = MathUtils.map(p.y, Constants.SPAWN_ROW_HEIGHT/2, Constants.SPAWN_ROW_HEIGHT, last.y, Constants.HEIGHT);
	                }
	                mob.init();
	                _allMobs.push(mob);
	                _container.addChild(mob);
	            }
            }
        }

        private function getPointsInColumn (x:uint, y:uint) : Array
        {
            var a : Array = [];
           	var bmp: BitmapData = _spawnMap.bitmapData;
           
            for(var _y: int = 0; _y < Constants.SPAWN_ROW_HEIGHT; _y++)
            {
                var pix: uint = bmp.getPixel32(x, _y+y);
                if(pix == 0xffffffff)
                {
                    a.push(pt(_x,_y));
                }
            }
            
            return a;
        }

        public function get allMobs () : Array {
            return _allMobs;
        }

        public function set allMobs ( allMobs : Array ) : void {
            _allMobs = allMobs;
        }

        public function release ( mob : Mob ) : void
        {
            _container.removeChild(mob);
            _allMobs.splice(_allMobs.indexOf(mob),1);
            mob.dispose();
        }
        public function stop() : void {
            _lock = true;
        }
    }
}
