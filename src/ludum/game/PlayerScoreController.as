package ludum.game
{
    import org.osflash.signals.Signal;

    import abe.com.mon.logs.Log;
    import abe.com.mon.core.Allocable;

    /**
     * @author cedric
     */
    public class PlayerScoreController implements Allocable
    {
        private var _difficulty : int;
        private var _comboLength : int;
        private var _comboMult : int;
        private var _comboTotal : int;
        private var _comboCurrent : int;
        private var _comboMax : int;
        private var _white : int;
        private var _black : int;
        private var _inCombo : Boolean;
        private var _whiteScore : int;
        private var _blackScore : int;
        private var _comboState : int;
        private var _lastColor : Number;
        private var _comboStartColor : int;
        private var _comboCompletionLength : int;
        static public const WHITE : int = 0;
        static public const BLACK : int = 1;
        static public const NO_COMBO : int = 0;
        static public const COMBO_SIZE : int = 1;
        static public const COMBO_COMPLETION : int = 2;
        
        public var comboStarted : Signal;
        public var comboFailed : Signal;
        public var comboSucceeded : Signal;
        public var comboLengthChanged : Signal;
        public var comboCompletionChanged : Signal;

        public function PlayerScoreController ( player : Player )
        {
        }

        public function update ( bias : Number, biasInSeconds : Number ) : void
        {
        }

        public function init () : void
        {
            _difficulty = 0;
            _comboLength = 0;
            _comboMult = 1;
            _comboTotal = 0;
            _comboCurrent = 0;
            _comboMax = 0;
            _comboState = 0;
            _comboStartColor = 0;
            _comboCompletionLength = 0;
            _whiteScore = 0;
            _blackScore = 0;
            _lastColor = -1;

            _inCombo = false;
            _white = 0;
            _black = 0;

            comboStarted = new Signal ();
            comboFailed = new Signal ();
            comboSucceeded = new Signal ();
            comboLengthChanged = new Signal ();
            comboCompletionChanged = new Signal ();
        }

        public function dispose () : void
        {
        }

        public function whiteHit () : void
        {
            handleCombo ( WHITE );
            _white++;
            _whiteScore += _comboMult;
        }

        public function blackHit () : void
        {
            handleCombo ( BLACK );
            _black++;
            _blackScore += _comboMult;
        }

        public function handleCombo ( type : int ) : void
        {
            switch(_comboState)
            {
                case NO_COMBO:
//                    CONFIG::DEBUG {
//                        Log.info ( "combo start" );
//                    }
                    _comboLength++;
                    _comboState = COMBO_SIZE;
                    _comboStartColor = type;
                    comboStarted.dispatch(this);
                    break;
                case COMBO_SIZE:
                    if (type == _lastColor)
                    {
                        _comboLength++;
                        comboLengthChanged.dispatch(this);
//                        CONFIG::DEBUG {
//                            Log.debug ( "combo size: " + _comboLength );                        
//                        }
                    }
                    else
                    {
                        _comboState = COMBO_COMPLETION;
                        _comboCompletionLength++;
                        comboCompletionChanged.dispatch(this);
//                        CONFIG::DEBUG {
//                            Log.info ( "combo completion phase" );
//                        }
                        if (_comboLength == 1)
                        {
                            succeededCombo ();
                        }
                    }
                    break;
                case COMBO_COMPLETION:
                    if (type == _comboStartColor)
                    {
                        failedCombo ();
                    }
                    else if (_comboCompletionLength < _comboLength)
                    {
                        _comboCompletionLength++;
                        comboCompletionChanged.dispatch(this);
//                        CONFIG::DEBUG {
//                            Log.debug ( "combo completion: " + _comboCompletionLength );                        
//                        }
                        if (_comboCompletionLength == _comboLength)
                        {
                            succeededCombo ();
                        }
                    }
                    else
                    {
                        failedCombo ();
                    }
                    break;
            }
            _lastColor = type;
        }

        public function succeededCombo () : void
        {
            _comboMult++;
            endCombo ();
            comboSucceeded.dispatch(this);
//            CONFIG::DEBUG {
//                Log.info ( "combo complete" );
//            }
        }

        public function failedCombo () : void
        {
            _comboMult = 1;
            endCombo ();
            comboFailed.dispatch(this);
//            CONFIG::DEBUG {
//                Log.error ( "combo failed" );            
//            }
        }

        public function endCombo () : void
        {
            _comboLength = 0;
            _comboCompletionLength = 0;
            _comboState = NO_COMBO;
            _difficulty = Math.floor(_comboMult / 10);
        }

        public function get difficulty () : int {
            return _difficulty;
        }

        public function get comboLength () : int {
            return _comboLength;
        }

        public function get comboMult () : int {
            return _comboMult;
        }

        public function get comboTotal () : int {
            return _comboTotal;
        }

        public function get comboCurrent () : int {
            return _comboCurrent;
        }

        public function get comboMax () : int {
            return _comboMax;
        }

        public function get white () : int {
            return _white;
        }

        public function get black () : int {
            return _black;
        }

        public function get total () : int {
            return _black + _white;
        }

        public function get comboCompletionLength () : int {
            return _comboCompletionLength;
        }

        public function get whiteScore () : int {
            return _whiteScore;
        }

        public function get blackScore () : int {
            return _blackScore;
        }
    }
}
