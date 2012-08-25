package ludum.states
{
    import abe.com.edia.states.UIState;
    import abe.com.edia.states.AbstractUIState;

    /**
     * @author cedric
     */
    public class EndState extends AbstractUIState
    {
        public function EndState ()
        {
            super ();
        }

        override public function activate ( previousState : UIState ) : void
        {
            super.activate ( previousState );
        }
        
        override public function release () : void
        {
            super.release ();
        }
    }
}
