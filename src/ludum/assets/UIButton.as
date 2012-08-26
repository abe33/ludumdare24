package ludum.assets
{
    import abe.com.ponents.buttons.Button;
    import abe.com.ponents.skinning.icons.Icon;

    [Skinable(skin="UIButton")]
    public class UIButton extends Button
    {
        public function UIButton ( actionOrLabel : * = null, icon : Icon = null )
        {
            super ( actionOrLabel, icon );
        }
    }
}
