package ludum.samples
{
    import abe.com.ponents.utils.ToolKit;
    import ludum.assets.Misc;

    import flash.text.Font;

    import ludum.effects.ShowMessage;
    import abe.com.edia.text.fx.show.DefaultTimedDisplayEffect;

    import flash.display.Sprite;
    import flash.filters.DropShadowFilter;

    /**
     * @author cedric
     */
    public class MessagesSample extends Sprite
    {
        public function MessagesSample ()
        {
            Font.registerFont(Misc.FONT);
            ToolKit.initializeToolKit(this);
            DefaultTimedDisplayEffect, DropShadowFilter;
            
            new ShowMessage(
            	"<fx:effect type='new abe.com.edia.text.fx.show::DefaultTimedDisplayEffect(20)'>"+
	            	"<fx:filter type='new flash.filters::DropShadowFilter(0,0,0,1,4,4,2)'>"+
	                	"<p align='center'>" +
	                    	"<font color='0xffffff' size='24' face='Diogenes' embedFonts='true'>"+
				                "Allright, you can come back to us.\n"+
				                "Your work on this world is done."+
	                        "</font>" +
	                    "</p>" +
	                "</fx:filter>"+
                "</fx:effect>", 10000).execute();
        }
    }
}
