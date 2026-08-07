local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local MaterialTextView = bindClass "com.google.android.material.textview.MaterialTextView"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local ColorStateList = bindClass "android.content.res.ColorStateList"

return
{
  LinearLayoutCompat,
  w="fill",
  gravity="center",
  {
    MaterialCardView,
    layout_margin="16dp",
    StrokeWidth="0dp",
    RippleColor=ColorStateList.valueOf(colorRipple),
    CardBackgroundColor=0,
    clickable=true,
    id="card",
    {
      LinearLayoutCompat,
      w="fill",
      h="fill",
      orientation="vertical",
      gravity="center",
      {
        MaterialCardView,
        layout_margin="16dp",
        radius="6dp",
        CardElevation="2dp",
        StrokeWidth="0dp",
        {
          AppCompatImageView,
          id="template_icon",
          w="95dp",
          h="140dp",
          scaleType="centerCrop",
        },
      },
      {
        AppCompatTextView,
        id="template_name",
        w="fill",
        singleLine=true,
        ellipsize="middle",
        layout_marginLeft="5dp",
        layout_marginRight="5dp",
        layout_marginBottom="10dp",
        gravity="center",
        textSize=TextSize,
        Typeface=Typeface_TTF(),
        text="Empty Activity",
      },
    },
    {
      MaterialCardView,
      h="36dp",
      radius="360dp",
      w="36dp",
      layout_gravity="center",
      id="check",
      Visibility=8,
      {
        AppCompatImageView,
        w="20dp",
        h="20dp",
        layout_gravity="center",
        src="res/drawable/ic_check.png",
        ColorFilter=Colors.colorPrimary
      };
    };
  }
}