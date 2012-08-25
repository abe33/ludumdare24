package ludum.game
{
    import abe.com.mon.logs.Log;
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
        public function Spawner ( container : Sprite, mask : Mask)
        {
           	_container = container;
            _mask = mask;
            _allMobs = [];
            _t = 0;
        }
        public function update(bias: Number, biasInSeconds:Number):void
        {
            _t += bias;
            if( _t > 2000 )
            {
                _t -= 2000;
                
                var whiteMob:WhiteMob = new WhiteMob();
                var blackMob:BlackMob = new BlackMob();
                
                whiteMob.init();
                blackMob.init();
                
                var last: Point = lastIn(_mask.curve.vertices);
                
                whiteMob.x = last.x;
                whiteMob.y = RandomUtils.rangeAB(10,last.y - 10);
                
                blackMob.x = last.x;
                blackMob.y = RandomUtils.rangeAB(last.y + 10, Constants.HEIGHT-10);
                
                _allMobs.push(whiteMob);
                _allMobs.push(blackMob);
                
                _container.addChild(whiteMob);
                _container.addChild(blackMob);
            }
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
    }
}
