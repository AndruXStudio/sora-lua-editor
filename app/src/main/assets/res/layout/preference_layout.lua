local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local RippleCardView = require "mods.view.RippleCardView"

return {
  RippleCardView,
  w="fill",
  {
    LinearLayoutCompat,
    w="fill",
    h="fill",
    gravity="center|left",
    {
      AppCompatImageView,
      layout_margin="16dp",
      w="24dp",
      w="24dp",
    },
    {
      LinearLayoutCompat,
      orientation="vertical",
      gravity="center",
      layout_weight=1,
      layout_margin="16dp",
      {
        AppCompatTextView,
        Alpha=0.9,
        textSize=TextSize + 2,
        Typeface=Typeface_TTF(),
        w="fill",
        textColor=Colors.colorOnBackground,
      },
      {
        AppCompatTextView,
        textSize=TextSize,
        Typeface=Typeface_TTF(),
        textColor=Colors.colorOutline,
        w="fill",
      },
    }
  }
}