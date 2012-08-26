package ludum.states
{
    import flash.utils.setTimeout;
    import abe.com.edia.commands.SimpleFadeOut;
    import abe.com.edia.commands.SimpleFadeIn;
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;
    import abe.com.mon.colors.Color;
    import abe.com.ponents.utils.ToolKit;

    import ludum.game.GameBoard;

    /**
     * @author cedric
     */
    public class PlayState extends AbstractUIState
    {
        public var board : GameBoard;
        
        public function PlayState ()
        {
            super ();
        }

        override public function activate ( previousState : UIState ) : void
        {
            super.activate ( previousState );
            board = new GameBoard();
            board.gameEnded.add(endGame);
            board.init();
            board.start();
            ToolKit.mainLevel.addChild(board);
            new SimpleFadeIn(ToolKit.popupLevel, Color.Black).execute();
        }

        private function endGame (... args) : void
        {
            new SimpleFadeOut(ToolKit.popupLevel, Color.Black);
            setTimeout(function():void{_manager.goto('end')}, 500);
        }
         
        override public function release () : void
        {
            super.release ();
            board.dispose();
            ToolKit.mainLevel.removeChild(board);
        } 
    }
}
