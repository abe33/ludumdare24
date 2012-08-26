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
    public class MobExplode implements Allocable, ImpulseListener
    {
        private var _level : Sprite;
        private var xplosion : MovieClip;
        private var _mob : Mob;
        public function MobExplode (level:Sprite, mob:Mob)
        {
            _level = level;
            _mob = mob;
            init();
        }

        public function init () : void
        {
            xplosion = new Misc.MOB_EXPLOSION() as MovieClip;
            xplosion.x = _mob.x;                
            xplosion.y = _mob.y;
            var c : Color = _mob is WhiteMob ? GameBoard.Blue : GameBoard.Red;
            xplosion.transform.colorTransform = c.toColorTransform(1);
            xplosion.addFrameScript(xplosion.totalFrames-1, dispose);
            Impulse.register(tick);
			_level.addChild(xplosion);
        }

        public function dispose () : void
        { 
            Impulse.unregister(tick);
            
          	xplosion.stop();
            xplosion.parent.removeChild(xplosion); 
            xplosion = null;
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            xplosion.x -= Constants.SCROLL_RATE * biasInSeconds;
        }
    }
}
