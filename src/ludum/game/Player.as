package ludum.game
{
    /**
     * @author cedric
     */
    public class Player
    {
        public var whiteAmount: Number;
        public var blackAmount : Number;

        public function Player ()
        {
            whiteAmount = 1;
            blackAmount = 1;
        }
        
        public function get ratio (): Number { return whiteAmount / blackAmount; }        

    }
}
