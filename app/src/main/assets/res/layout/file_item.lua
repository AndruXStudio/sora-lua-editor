local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"

return {
  LinearLayoutCompat,
  w="fill",
  h="64dp",
  paddingTop="2dp",
  paddingBottom="2dp",
  paddingLeft="8dp",
  paddingRight="8dp",
  {
    MaterialCardView,
    radius="32dp",
    w="fill",
    h="fill",
    StrokeWidth=0,
    CardBackgroundColor=0,
    layout_margin="4dp",
    id="contents",
    {
      LinearLayoutCompat,
      w="fill",
      h="fill",
      gravity="left|center",
      id="linear",
      {
        AppCompatImageView,
        layout_marginLeft="14dp",
        w="28dp",
        h="26dp",
        layout_marginRight="8dp",
        id="icon",
      },
      {
        AppCompatTextView,
        textSize=TextSize + 3,
        singleLine=true,
        ellipsize="middle",
        id="name",
        Typeface=Typeface_TTF(3),
        textColor=Colors.colorOnBackground,
        layout_marginLeft="8dp",
        layout_marginRight="8dp",
        layout_weight=1,
      },
    },
  },
}