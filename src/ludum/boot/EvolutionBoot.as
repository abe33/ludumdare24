package ludum.boot
{
    import flash.display.Sprite;

    /**
     * @author cedric
     */
    public class EvolutionBoot extends BootLoader
    {
        protected var _container : Sprite;
        
        public function EvolutionBoot ()
        {
            super ();
        }
        
        override protected function createProgressPanel () : void
        {
            _container = new Sprite();
            addChild(_container);
        }
        
        override protected function releaseProgressPanel () : void
        {
            removeChild(_container);
        }
        override protected function setProgressLabel ( s : String ) : void
        {
        }
        override protected function setProgressValue ( n : Number ) : void
        {
            
        }
        
    }
}
