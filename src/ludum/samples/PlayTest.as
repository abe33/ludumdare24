package ludum.samples
{
    import ludum.states.EndState;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.states.UIStateMachine;
    import abe.com.mon.utils.StageUtils;
    import abe.com.motion.Impulse;
    import abe.com.patibility.lang._;
    import abe.com.ponents.monitors.AllocatorGraphMonitor;
    import abe.com.ponents.monitors.GraphMonitorCaption;
    import abe.com.ponents.monitors.ParticleGraphMonitor;
    import abe.com.ponents.skinning.SkinManagerInstance;
    import abe.com.ponents.skinning.icons.magicIconBuild;
    import abe.com.ponents.tabs.SimpleTab;
    import abe.com.ponents.utils.ToolKit;

    import ludum.assets.Misc;
    import ludum.assets.Sounds;
    import ludum.assets.UISkin;
    import ludum.states.PlayState;

    import flash.display.Sprite;
    import flash.text.Font;

    [SWF(frameRate='60')]
    public class PlayTest extends Sprite
    {
        private var stateManager : UIStateMachine;
        public function PlayTest ()
        {
            Font.registerFont(Misc.DIOGENES);
            Font.registerFont(Misc.GOTHAM);
            SkinManagerInstance.registerMetaStyle( UISkin );
            
            ToolKit.initializeToolKit ( this );
            
            SoundManagerInstance.addLibrarySound( Sounds.BACKGROUND_MUSIC, 	"music", 1 );
            SoundManagerInstance.addLibrarySound( Sounds.LOOP, "loop", 1);
            SoundManagerInstance.addLibrarySound( Sounds.SWOOSH,	"swoosh",	4 );
            
            Impulse.smoothFactor = 4;
            
            CONFIG::RELEASE {
                FEATURES::MENU_CONTEXT {
                	StageUtils.noMenu();
                }
            }
            CONFIG::DEBUG {
                ToolKit.debugPanel.addTab ( new SimpleTab ( _("Particles"), new ParticleGraphMonitor (), magicIconBuild ( ParticleGraphMonitor.ICON ) ) );
                
                var alloc : AllocatorGraphMonitor = new AllocatorGraphMonitor();
                //alloc.monitor.addRecorder( new AllocatorRecorder(AllocatorInstance, TextFieldChar, 0, new Range(0,400), Color.Chocolate ) );
                //alloc.monitor.addRecorder( new AllocatorRecorder(AllocatorInstance, TextFieldChar, 2, new Range(0,400), Color.DarkGoldenrod ) );
                alloc.caption.layoutMode = GraphMonitorCaption.COLUMN_2_LAYOUT_MODE;
                
                ToolKit.debugPanel.addTab ( new SimpleTab ( _("Allocators"), alloc ) );
            }
            
            stateManager = new UIStateMachine();
           
            stateManager.addState( new PlayState(), 'play');
            stateManager.addState( new EndState(), 'end');
            stateManager.goto("play");
        }
    }
}
