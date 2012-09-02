package ludum
{
    /**
     * @author cedric
     */
    public class Constants
    {
        static public const WIDTH: int = 640;
        static public const HEIGHT: int = 480;
                
        static public const BACKGROUND_TILE_WIDTH: int = 384;
        static public const BACKGROUND_TILE_HEIGHT : int = 96;
        
        static public const BACKGROUND_PROPS_WIDTH: int = 256;
        static public const BACKGROUND_PROPS_HEIGHT : int = 256;
        
        static public const SCROLL_RATE: Number = 200;
        
        public static const MOTION_SMOOTHNESS : Number = 1;
        public static const FRICTION : Number = 0.8;
        public static const MAX_DISTANCE : Number = 100;
        public static const ROTATION_SPEED : Number = 10;
        public static const MIN_DISTANCE : Number = 5;
        public static const BURST_SPEED : Number = 500;
        
        public static const MAX_BRUSHES_SIZE : Number = 12;
        public static const BRUSHES_ROTATION_SPEED : Number = 5;
        public static const SPLIT_BALANCE : Number = 180;
         
        public static const MOB_SPRITE_WIDTH : Number = 32;
        public static const MOB_SPRITE_HEIGHT : Number = 32;
        public static const COLLISION_DISTANCE : Number = 30;
        public static const SPAWN_OUT : Number = -60;
        public static const MOUSE_PROXIMITY : Number = 30;
        public static const MOUSE_LIMIT : Number = 0;
        public static const SPLATS_WIDTH : int = 128;
        public static const SPLATS_HEIGHT : int = 128;
        public static const TRACE_PATH_MEMORY : Number = 10;
        public static const TURN_THRESHOLD : Number = 1.4;
        public static const BURST_TIMEOUT : Number = 500;
        public static const PLAYER_STATE_SWITCH : Number = 10;
        public static const SPAWNING_FACTOR : Number = 0.5;
        public static const SPAWNING_COOLDOWN : Number = 500;
        public static const BURST_COOLDOWN : Number = 500;

//        public static const GAME_DURATION : Number = 10 * 1000;
        public static const GAME_DURATION : Number = 3.7 * 60 * 1000;
        public static const END_GAME_GAP : Number = 3500;
        public static const BURST_DISTANCE : Number = 300;
    }
}