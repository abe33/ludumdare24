package ludum.game
{
    import abe.com.mon.colors.Color;
    import abe.com.mon.core.Allocable;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;

    import ludum.Constants;
    import ludum.assets.Misc;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    /**
     * @author cedric
     * 
     */
    public class MobAbsorb implements Allocable
    {
        private var _level : Sprite;
        public var view : MovieClip;
        private var _mob : Mob;

        public function MobAbsorb ( level : Sprite, mob : Mob )
        {
            _level = level;
            _mob = mob;
            init();
        }

        public function init () : void
        {
            view = new Misc.BALANCE_FLASH() as MovieClip;
            view.x = _mob.x;                
            view.y = _mob.y;
            view.scaleX = view.scaleY = 2;
            var c : Color = _mob is BlackMob ? GameBoard.Blue : GameBoard.Red;
            view.transform.colorTransform = c.toColorTransform(1);
            view.addFrameScript(view.totalFrames-1, dispose);
			_level.addChild(view);
        }

        public function dispose () : void
        {
          	view.stop();
            view.parent.removeChild(view); 
            view = null; 
        }
    }
}
