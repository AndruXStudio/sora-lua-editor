local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"

return {
  LinearLayoutCompat,
  paddingVertical="16dp",
  paddingHorizontal="8dp",
  orientation="vertical",
  gravity="center",
  {
    MaterialCardView,
    radius="360dp",
    w="40dp",
    h="40dp",
    StrokeWidth=0,
    {
      AppCompatImageView,
      layout_margin="8dp",
      w="fill",
      h="fill",
    },
  },
  {
    AppCompatTextView,
    textSize=TextSize,
    Typeface=Typeface_TTF(),
    layout_marginTop="4dp",
    text="Build",
    textColor=Colors.colorPrimary
  }
}