package ludum.game
{
    import abe.com.edia.text.AdvancedTextField;
    import abe.com.mon.core.Allocable;
    import abe.com.mon.utils.StringUtils;

    import flash.display.Sprite;

    /**
     * @author cedric
     */
    public class ComboUI extends Sprite implements Allocable
    {
        private var _scorer : PlayerScoreController;
        private var _txt : AdvancedTextField;
        public function ComboUI (scorer: PlayerScoreController)
        {
            _scorer = scorer;
        }
        
        public function update(bias:Number, biasInSeconds:Number):void
        {
            
        }

        public function init () : void
        {
            _scorer.comboFailed.add(comboFailed);
            _scorer.comboSucceeded.add(comboSucceeded);
            _scorer.comboStarted.add(comboStarted);
            _scorer.comboLengthChanged.add(comboLengthChanged);
            _scorer.comboCompletionChanged.add(comboCompletionChanged);
            
            _txt = new AdvancedTextField();
            _txt.width = 200;
            _txt.x = -100;
            updateMult();
            addChild(_txt);
            
        }

        public function dispose () : void
        {
        }
        
        private function comboCompletionChanged (scorer:PlayerScoreController) : void
        {
         	updateMult();   
        }

        private function comboLengthChanged (scorer:PlayerScoreController) : void
        {
         	updateMult();   
        }

        private function comboStarted (scorer:PlayerScoreController) : void
        {
         	updateMult();   
        }

        private function comboSucceeded (scorer:PlayerScoreController) : void
        {
         	updateMult();   
        }


        private function comboFailed (scorer:PlayerScoreController) : void
        {
            updateMult();
        }
        private function updateMult () : void
        {
            var white: String;
            var black: String;
            
            if(_scorer.comboStartColor == PlayerScoreController.WHITE)
            {
                white = StringUtils.fill( '', _scorer.comboLength);
                black = StringUtils.fill( '', _scorer.comboCompletionLength) + 
                		StringUtils.fill( '', _scorer.comboLength - _scorer.comboCompletionLength, ' ');
            }
            else
            {
               	black = StringUtils.fill( '', _scorer.comboLength);
               	white = StringUtils.fill( '', _scorer.comboLength - _scorer.comboCompletionLength, ' ') + 
               	        StringUtils.fill( '', _scorer.comboCompletionLength); 
            }
            
            _txt.htmlText = '<p align="center">'+ 
            					white +  ' - x'+_scorer.comboMult+' - '+ black +
                                '\n' + 
                                StringUtils.fill(_scorer.white, 3) + ' | ' + StringUtils.fill(_scorer.black, 3) + 
                                '\n' +
                                StringUtils.fill(_scorer.whiteScore, 9) + ' | ' + StringUtils.fill(_scorer.blackScore, 9) +
                            '</p>';
        }
    }
}
