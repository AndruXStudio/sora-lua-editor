local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"

return {
  LinearLayoutCompat,
  padding="16dp",
  w="fill",
  {
    AppCompatTextView,
    layout_marginLeft="16dp",
    layout_marginRight="16dp",
    textSize=TextSize,
    Typeface=Typeface_TTF(),
    id="text",
    h="fill",
    w="fill",
  }
}