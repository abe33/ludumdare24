package ludum.game
{
    import ludum.assets.BlackSkin;
    import ludum.game.Mob;

    /**
     * @author cedric
     */
    public class BlackMob extends Mob
    {
        public function BlackMob ()
        {
            super ();
            SKIN = BlackSkin;
        }
    }
}
