package ludum.assets
{
    /**
     * @author cedric
     */
    public class Sounds
    {
        [Embed(source="../../../assets/swf/gfx.swf",symbol="bgmusic")]
        static public var BACKGROUND_MUSIC:Class;
        
        [Embed(source="../../../assets/swf/gfx.swf",symbol="loop")]
        static public var LOOP:Class;
        
       	[Embed(source="../../../assets/swf/gfx.swf",symbol="swoosh")]
        static public var SWOOSH:Class;
        
    }
}
