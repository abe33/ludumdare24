package ludum.samples
{
    import ludum.effects.BitmapScroller;
    import abe.com.motion.Impulse;
    import abe.com.motion.ImpulseListener;
    import abe.com.ponents.utils.ToolKit;

    import ludum.effects.Tracer;
    import ludum.game.Player;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.utils.ByteArray;

    public class PlayerSample extends Sprite implements ImpulseListener
    {
        [Embed(source='../shaders/invert.pbj', mimeType="application/octet-stream")]
        private var SHADER:Class; 
        
        private var player : Player;
        private var shader : Shader;
        private var tracer : Tracer;
        private var bmp : BitmapData;
        private var playerLevel : Sprite;
        private var back : Shape;
        private var scroller : BitmapScroller;
        
        public function PlayerSample ()
        {
            ToolKit.initializeToolKit(this);
            
            player = new Player();
            player.init();
            
            player.x = 100;
            player.y = 240;
                       
            bmp = new BitmapData(640, 480, true, 0x00ffffff); 
            
            Impulse.register(tick);  
            
            back = new Shape();
            
            back.graphics.beginFill(0);       
            back.graphics.moveTo(0,0);       
            back.graphics.lineTo(640,480);       
            back.graphics.lineTo(0,480);       
            back.graphics.lineTo(0,0);
            back.graphics.endFill();
            
            back.graphics.beginFill(0xffffff);       
            back.graphics.moveTo(0,0);       
            back.graphics.lineTo(640,0);       
            back.graphics.lineTo(640,480);       
            back.graphics.lineTo(0,0);
            back.graphics.endFill();
            playerLevel = new Sprite();
            
            var shader: Shader = new Shader(new SHADER() as ByteArray);
            playerLevel.blendShader = shader;
            playerLevel.blendMode = "shader";
            playerLevel.cacheAsBitmap = true;
            
            ToolKit.mainLevel.addChild(back); 
            ToolKit.mainLevel.addChild(playerLevel);
            
            tracer = new Tracer(player, bmp);
            tracer.init();
            var b : Bitmap = new Bitmap(bmp);
            
            scroller = new BitmapScroller(bmp);
            
            playerLevel.addChild(b);
            playerLevel.addChild(player);
        }

        public function tick ( bias : Number, biasInSeconds : Number, currentTime : Number ) : void
        {
            player.update(bias, biasInSeconds);
            scroller.scroll(biasInSeconds);
            tracer.scroll(biasInSeconds);
            tracer.update(bias, biasInSeconds);
        }
        
    }
}
