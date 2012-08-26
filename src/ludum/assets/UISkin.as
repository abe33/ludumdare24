package ludum.assets
{
    import abe.com.mon.colors.Color;

    import flash.filters.DropShadowFilter;
    [Skin(define="UIButton",
    	  inherit="EmptyComponent",
          custom_embedFonts="true",
          
          state__all__innerFilters="ludum.assets::UISkin.TEXT_FILTERS",
          state__all__format="new txt::TextFormat('Gotham',20)",
          state__all__textColor="color(White)",
          state__pressed__textColor="color(Black)",
          state__all__background="color('#ffe879')",
          state__pressed__background="color('#f20000')",
          state__all__insets="new cutils::Insets(4,4,4,4)"
    )] 
    public class UISkin
    {
        static public const TEXT_FILTERS:Array = [new DropShadowFilter(0, 0, Color.OrangeRed.hexa, 1, 4, 4, 1)];
        static public const TEXT_FILTERS_FAT:Array = [new DropShadowFilter(0, 0, Color.OrangeRed.hexa, 1, 10, 10, 1, 3)];
    }
}
