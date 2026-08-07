local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local TextInputEditText = bindClass "com.google.android.material.textfield.TextInputEditText"

return {
  LinearLayoutCompat,
  {
    MaterialCardView,
    w="fill",
    h="56dp",
    layout_margin="18dp",
    layout_marginBottom="12dp",
    layout_marginTop="8dp",
    radius="360dp",
    StrokeWidth=0,
    CardBackgroundColor=Colors.colorSurfaceContainerHigh,
    {
      LinearLayoutCompat,
      w="fill",
      h="fill",
      gravity="center|left",
      {
        AppCompatImageView,
        h="48dp",
        w="48dp",
        padding="12dp",
        layout_marginLeft="2dp",
        ColorFilter=Colors.colorOnSurfaceVariant,
        ImageDrawable=res.drawable.ic_search,
      },
      {
        TextInputEditText,
        h="fill",
        w="fill",
        singleLine=true,
        hintTextColor=Colors.colorOutline,
        textSize=TextSize + 2,
        Typeface=Typeface_TTF(),
        layout_marginRight="8dp",
        backgroundColor="0x00000000",
      }
    }
  }
}