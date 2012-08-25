package ludum.samples
{
    import abe.com.ponents.utils.ToolKit;

    import flash.display.Shader;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.utils.ByteArray;

    /**
     * @author cedric
     */
    public class ShaderTest extends Sprite
    {
        [Embed(source='../shaders/invert.pbj', mimeType="application/octet-stream")]
        private var SHADER:Class; 
        
        private var player : Shape;
        private var shader : Shader;
        public function ShaderTest ()
        {
            ToolKit.initializeToolKit(this);
            
            player = new Shape();
            
            player.graphics.beginFill(0);
            player.graphics.drawCircle(40,40,20);
            player.graphics.endFill();
            
            player.graphics.beginFill(0xffffff);
            player.graphics.drawCircle(35,30,5);
            player.graphics.endFill();
            
                                    
            ToolKit.mainLevel.addChild(player);
                        
            ToolKit.mainLevel.graphics.beginFill(0xff);       
            ToolKit.mainLevel.graphics.moveTo(0,0);       
            ToolKit.mainLevel.graphics.lineTo(640,480);       
            ToolKit.mainLevel.graphics.lineTo(0,480);       
            ToolKit.mainLevel.graphics.lineTo(0,0);
            ToolKit.mainLevel.graphics.endFill(); 
            
            shader = new Shader(new SHADER() as ByteArray);
            player.blendShader = shader;
            player.blendMode = "shader";
        }
    }
}
