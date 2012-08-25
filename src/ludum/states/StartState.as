package ludum.states
{
    import abe.com.edia.states.AbstractUIState;
    import abe.com.edia.states.UIState;

    /**
     * @author cedric
     */
    public class StartState extends AbstractUIState
    {
        public function StartState ()
        {
            super ();
        }
        override public function activate ( previousState : UIState ) : void
        {
        }

        override public function release () : void
        {
            super.release ();
        }
        
        
        
    }
}
