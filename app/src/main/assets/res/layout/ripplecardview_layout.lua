local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local ColorStateList = bindClass "android.content.res.ColorStateList"

return {
  MaterialCardView,
  w="fill",
  h="wrap",
  CardBackgroundColor=0,
  radius=0,
  StrokeWidth=0,
  CardElevation=0,
  clickable=true,
  RippleColor=ColorStateList.valueOf(colorRipple),
}