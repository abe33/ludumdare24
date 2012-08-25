package ludum.states
{
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;
    import abe.com.ponents.utils.ToolKit;

    import ludum.game.GameBoard;

    /**
     * @author cedric
     */
    public class PlayState extends AbstractUIState
    {
        private var board : GameBoard;
        
        public function PlayState ()
        {
            super ();
        }

        override public function activate ( previousState : UIState ) : void
        {
            super.activate ( previousState );
            board = new GameBoard();
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
