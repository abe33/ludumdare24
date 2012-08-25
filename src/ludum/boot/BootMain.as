package ludum.boot
{
    import flash.display.Sprite;
    import flash.events.Event;

    public class BootMain extends Sprite
    {
        protected var _options : Object;

        public function BootMain ( options : Object = null )
        {
            _options = options ? options : {
                'translations':{},
                'bootloader':null
            };
            addEventListener(Event.ADDED_TO_STAGE, addedToStage );
        }
        public function get options () : Object { return _options; }
        public function set options ( options : Object ) : void { _options = options; }
        
        public function init () : void {}
        
        private function addedToStage ( event : Event ) : void
        {
            init();
            removeEventListener ( Event.ADDED_TO_STAGE, addedToStage );
        }
    }
}
