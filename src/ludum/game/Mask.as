package ludum.game
{
    import abe.com.mon.geom.SmoothSpline;
    import abe.com.mon.randoms.LaggedFibonnacciRandom;
    import abe.com.mon.randoms.Random;

    import ludum.Constants;

    import flash.display.Shape;
    import flash.geom.Point;
    /**
     * 
     * @author cedric
     */
    public class Mask
    {
        protected var _curve: SmoothSpline;
        protected var _ratio : Number;
        protected var _t : Number;
        private var _redrawLimit : Number;
        private var _random : Random;
        private var _balance : Number;
        
        public function Mask ()
        { 
            _random = new Random(new LaggedFibonnacciRandom(Math.floor(Math.random()*156506)));
            _t = 0;
            _redrawLimit = -100;
           
            var a : Array = new Array();
			for(var i:int=-1; i <= 11; i++)
            {
                a.push(spawnNextPoint(0, i));
            } 
            _curve = new SmoothSpline(a, 0.4, 3, 120);
        }
        
        public function spawnNextPoint(ratio:Number = 0, pos: int = 12):Point
        {
            return new Point(pos * (Constants.WIDTH / 10), Constants.HEIGHT / 2 + _random.ibalance(50) + ratio * Constants.SPLIT_BALANCE);
        }
        
        public function set ratio(n:Number):void
        {
            _ratio = n;
        }
        
        public function update(bias: Number, biasInSecond:Number): void
        {         
              
            var a: Array = _curve.vertices;
            for each(var pt:Point in a)
            {
                pt.x -= Constants.SCROLL_RATE * biasInSecond;
            }
            
            if( a[0].x < _redrawLimit)
            {
                a.shift();
                a.push(spawnNextPoint(_ratio));
            }
            _curve.vertices = a;
            _t += bias;
            
        }

        public function draw ( shape : Shape ) : void
        {
            shape.graphics.clear();
            shape.graphics.beginFill(0);
            var points : Array = _curve.points;
            
            shape.graphics.moveTo(points[0].x, points[0].y);
            for(var i:int=1;i<points.length;i++)
            {
                var pt: Point = points[i];
                shape.graphics.lineTo(pt.x, pt.y);
            }
            shape.graphics.lineTo(Constants.WIDTH-_redrawLimit, Constants.HEIGHT+50);
            shape.graphics.lineTo(_redrawLimit, Constants.HEIGHT+50);
            shape.graphics.lineTo(_redrawLimit, points[0].y);
            shape.graphics.endFill ();
        }

        public function get curve () : SmoothSpline {
            return _curve;
        }

        public function set curve ( curve : SmoothSpline ) : void {
            _curve = curve;
        }
    }
}
