package ludum.samples
{
    import abe.com.edia.states.UIStateMachine;
    import abe.com.ponents.skinning.SkinManagerInstance;
    import abe.com.ponents.utils.ToolKit;

    import ludum.assets.Misc;
    import ludum.assets.UISkin;
    import ludum.states.EndState;

    import flash.display.Sprite;
    import flash.text.Font;

    /**
     * @author cedric
     */
    public class EndStateTest extends Sprite
    {
        private var stateManager : UIStateMachine;
        public function EndStateTest ()
        {
            Font.registerFont(Misc.DIOGENES);
            Font.registerFont(Misc.GOTHAM);
            SkinManagerInstance.registerMetaStyle( UISkin );
            
            ToolKit.initializeToolKit ( this );
            
            stateManager = new UIStateMachine();
           
            stateManager.addState( new EndState(), 'end');
            stateManager.goto("end");
        }
    }
}
