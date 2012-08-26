package ludum.assets
{
    /**
     * @author cedric
     */
    public class Misc
    {
        [Embed(source='../../../assets/splatters.png')]
        static public const SPLATS: Class;
        
        [Embed(source='../../../assets/swf/gfx.swf', symbol='gfx.Balance')]
        static public const BALANCE: Class;
        
        [Embed(source='../../../assets/swf/gfx.swf', symbol='gfx.Explode')]
        static public const MOB_EXPLOSION: Class;
       
        [Embed(source='../../../assets/swf/gfx.swf', symbol='gfx.Parts')]
        static public const MOB_PARTICLES: Class;
        
        [Embed(source='../../../assets/swf/gfx.swf', symbol='gfx.ProgBar')]
        static public const PROGRESS_BAR: Class;
        
        [Embed(source='../../../assets/swf/gfx.swf', symbol='gfx.Absorbe')]
        static public const BALANCE_FLASH: Class;
    }
}
