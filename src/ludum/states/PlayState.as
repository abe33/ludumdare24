package ludum.states
{
    import abe.com.ponents.utils.ToolKit;
    import abe.com.ponents.nodes.actions.AddNodeAction;
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;

    import ludum.game.GameBoard;
    import ludum.game.Player;

    /**
     * @author cedric
     */
    public class PlayState extends AbstractUIState
    {
        public var player : Player;
        private var board : GameBoard;
        
        public function PlayState ()
        {
            super ();
        }

        override public function activate ( previousState : UIState ) : void
        {
            super.activate ( previousState );
            player = new Player();
            board = new GameBoard(player);
            board.init();
            board.start();
            ToolKit.mainLevel.addChild(board);
        }
         
        override public function release () : void
        {
            super.release ();
            board.dispose();
        } 
    }
}
