package ludum
{
    import ludum.assets.Sounds;
    import abe.com.edia.sounds.SoundManagerInstance;
    import abe.com.edia.states.UIStateMachine;
    import abe.com.mon.utils.StageUtils;
    import abe.com.motion.Impulse;
    import abe.com.patibility.lang._;
    import abe.com.ponents.monitors.AllocatorGraphMonitor;
    import abe.com.ponents.monitors.GraphMonitorCaption;
    import abe.com.ponents.monitors.ParticleGraphMonitor;
    import abe.com.ponents.skinning.icons.magicIconBuild;
    import abe.com.ponents.tabs.SimpleTab;
    import abe.com.ponents.utils.ToolKit;

    import ludum.boot.BootMain;
    import ludum.states.EndState;
    import ludum.states.PlayState;
    import ludum.states.StartState;

    [SWF(backgroundColor="#ffffff", frameRate="60")]
	[Frame(factoryClass="ludum.boot.EvolutionBoot")]
    public class Evolution extends BootMain
    {
        static public function getOptions():Object
        {
            return _instance.options;
        }
        static protected var _instance : Evolution;
		private var stateManager : UIStateMachine;
        
        public function Evolution (options: Object = null)
        {
            super(options);
            _instance = this;
        } 
        
        override public function init () : void
        {
            super.init ();
            ToolKit.initializeToolKit ( this );
            
            SoundManagerInstance.addLibrarySound( Sounds.BACKGROUND_MUSIC, 	"music", 1 );
            SoundManagerInstance.addLibrarySound( Sounds.LOOP, "loop", 1);
            SoundManagerInstance.addLibrarySound( Sounds.SWOOSH,	"swoosh",	4 );
            
            stateManager = new UIStateMachine();
            stateManager.addState( new StartState(), 'start');
            stateManager.addState( new PlayState(), 'play');
            stateManager.addState( new EndState(), 'end');
            
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
            
            stateManager.goto("start");
        }
    }
}
