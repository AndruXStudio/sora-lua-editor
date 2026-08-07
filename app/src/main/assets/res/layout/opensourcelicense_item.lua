local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local ColorStateList = bindClass "android.content.res.ColorStateList"

return {
  LinearLayoutCompat,
  w="fill",
  orientation="vertical",
  {
    MaterialCardView,
    layout_margin="8dp",
    layout_marginTop="8dp",
    layout_marginLeft="20dp",
    layout_marginRight="20dp",
    w="fill",
    checkable=true,
    focusable=true,
    clickable=true,
    CardBackgroundColor=0,
    StrokeColor=Colors.colorSurfaceVariant,
    RippleColor=ColorStateList.valueOf(colorRipple),
    id="cardView",
    {
      LinearLayoutCompat,
      h="fill",
      w="fill",
      {
        LinearLayoutCompat,
        h="fill",
        w="fill",
        layout_margin="16dp",
        orientation="vertical",
        {
          AppCompatTextView,
          textSize=TextSize + 2,
          id="name",
          textColor=Colors.colorPrimary,
          Typeface=Typeface_TTF(2),
        },
        {
          AppCompatTextView,
          id="message",
          layout_marginTop="8dp",
          textColor=Colors.colorOnBackground,
          Typeface=Typeface_TTF(),
          textSize=TextSize,
        },
        {
          AppCompatTextView,
          id="license",
          textColor=Colors.colorOutline,
          Typeface=Typeface_TTF(),
          textSize=TextSize,
        },
      },
    },
  },
}