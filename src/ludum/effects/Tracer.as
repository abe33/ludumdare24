package ludum.effects
{
    import abe.com.mon.core.Allocable;
    import abe.com.mon.geom.pt;
    import abe.com.mon.utils.MathUtils;
    import abe.com.mon.utils.PointUtils;
    import abe.com.mon.utils.arrays.firstIn;

    import ludum.Constants;

    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.geom.Point;

    /**
     * @author cedric
     */
    public class Tracer implements Allocable
    {
        private var _target : DisplayObject;
        private var _canvas : BitmapData;
        private var _shape: Shape;
        
        private var lastPosition:Point;
        private var currentPosition:Point;
        
        private var _brushesPositions: Array;
        private var _brushesLastPositions: Array;
        private var _brushesSizes: Array;
        private var _brushesLastSizes : Array;
        private var _brushesSizesFactor : Array;
        private var _lastVec : Array;
        private var _splashes:Array;
        
        public function Tracer (target: DisplayObject, canvas: BitmapData)
        {
            _target = target;
            _canvas = canvas;
        }

        public function init () : void
        {
            lastPosition = pt(_target.x, _target.y);
            currentPosition = pt(_target.x, _target.y);
            _brushesPositions = [pt(6,4),pt(4,-3),pt(-4,2)];
            _brushesLastPositions = [pt(6,4),pt(4,-3),pt(-4,2)];
            _brushesSizes = [2,3,4];
            _brushesLastSizes = [2,3,4];
            _brushesSizesFactor = [.2, .4, .9];
            _lastVec = [];
            _shape = new Shape();
            _splashes = [];
        }

        public function dispose () : void
        {
 			for each( var s :TraceSplash in _splashes)
            	s.dispose();           
        }

        public function scroll ( bias : Number ) : void
        {
            var amount: Number = Math.floor(Constants.SCROLL_RATE * bias);
            lastPosition.x -= amount;
        }
        public function update ( bias : Number, biasInSeconds : Number ) : void
        {
            _shape.graphics.clear();
            currentPosition = pt(_target.x, _target.y);
            var vec: Point = lastPosition.subtract(currentPosition);
            
            var l: int = _brushesPositions.length;
            for(var i:int=0; i<l; i++)
            {
                updateBrush(i,biasInSeconds);
            }
            
            _canvas.draw(_shape);
            
            var oldVec:Point = firstIn(_lastVec);
            
            if(oldVec)
            {
	            var angle:Number = PointUtils.getAngle(vec, oldVec);
                var tangeant : Number = Math.atan2(vec.y - oldVec.y, vec.x - oldVec.x);
	            if( Math.abs(angle) > Constants.TURN_THRESHOLD )
                {
                    var splash : TraceSplash = new TraceSplash(_canvas);
                    splash.x = _target.x;
                    splash.y = _target.y;
                    splash.rotation = MathUtils.rad2deg(tangeant +1.5 * (angle > 0 ? 1 : -1));
                    _target.parent.addChildAt(splash, 0);
                    _splashes.push(splash);
                }
            }
            
            lastPosition = currentPosition;
            _lastVec.push(vec);
            if( _lastVec.length > Constants.TRACE_PATH_MEMORY )
            	_lastVec.shift();
        }

        private function updateBrush ( i : int, b:Number ) : void
        {
            var pos: Point = PointUtils.rotate(_brushesLastPositions[i], b * Constants.BRUSHES_ROTATION_SPEED);
            var lastPos: Point = _brushesLastPositions[i];
            var size: Number = _brushesSizes[i];
            var lastSize: Number = _brushesLastSizes[i];
            var factor: Number = _brushesSizesFactor[i];
            
            var vec:Point = lastPosition.subtract(currentPosition);
            size = Math.min(2 + vec.length/2, Constants.MAX_BRUSHES_SIZE) * factor;
            var normal: Point = PointUtils.rotate(vec.clone(), Math.PI/2);
            var normalLast : Point = normal.clone();
            
            normal.normalize(size);
            normalLast.normalize(lastSize);
            
            _shape.graphics.beginFill(0);
            _shape.graphics.drawCircle(currentPosition.x + pos.x, currentPosition.y + pos.y, size);
            _shape.graphics.endFill();

            _shape.graphics.beginFill(0);
            _shape.graphics.drawCircle(lastPosition.x + lastPos.x, lastPosition.y + lastPos.y, lastSize);
            _shape.graphics.endFill();

            _shape.graphics.beginFill(0);
            _shape.graphics.moveTo(lastPosition.x + lastPos.x - normalLast.x, lastPosition.y + lastPos.y - normalLast.y);
            _shape.graphics.lineTo(lastPosition.x + lastPos.x + normalLast.x, lastPosition.y + lastPos.y + normalLast.y);
            _shape.graphics.lineTo(currentPosition.x + pos.x + normal.x, currentPosition.y + pos.y + normal.y);
            _shape.graphics.lineTo(currentPosition.x + pos.x - normal.x, currentPosition.y + pos.y - normal.y);
            _shape.graphics.lineTo(lastPosition.x + lastPos.x - normalLast.x, lastPosition.y + lastPos.y - normalLast.y);
            _shape.graphics.endFill();
            
            _brushesLastSizes[i] = size;            
            _brushesLastPositions[i] = pos;            
            
        }
    }
}
