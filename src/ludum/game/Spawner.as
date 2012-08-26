package ludum.game
{
    import abe.com.mon.utils.RandomUtils;
    import abe.com.mon.utils.arrays.lastIn;

    import ludum.Constants;

    import flash.display.Sprite;
    import flash.geom.Point;
    /**
     * @author cedric
     */
    public class Spawner
    {
        private var _container : Sprite;
        private var _t : int;
        private var _allMobs : Array;
        private var _mask : Mask;
        private var _quantity : Number;
        private var _factor : Number;
        private var _lock : Boolean;
        public function Spawner ( container : Sprite, mask : Mask)
        {
           	_container = container;
            _mask = mask;
            _allMobs = [];
            _t = 0;
            _quantity = 1;
            _factor = 0.01;
            
        }
        public function update(bias: Number, biasInSeconds:Number):void
        {
            if(_lock ) return;
            
            _t += bias;
            if( _quantity >= 1 && _t >= Constants.SPAWNING_COOLDOWN)
            {
                _t -= Constants.SPAWNING_COOLDOWN;
                var whiteMob:WhiteMob = new WhiteMob();
                var blackMob:BlackMob = new BlackMob();
                
                whiteMob.init();
                blackMob.init();
                
                var last: Point = lastIn(_mask.curve.vertices);
                
                whiteMob.x = last.x + RandomUtils.balance(100);
                whiteMob.y = RandomUtils.rangeAB(20,last.y - 20);
                
                blackMob.x = last.x + RandomUtils.balance(100);
                blackMob.y = RandomUtils.rangeAB(last.y + 20, Constants.HEIGHT-20);
                
                _allMobs.push(whiteMob);
                _allMobs.push(blackMob);
                
                _container.addChild(whiteMob);
                _container.addChild(blackMob);
                _quantity -= 1;
            }
            _quantity += biasInSeconds * _factor;
            _factor += biasInSeconds / 100;
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
