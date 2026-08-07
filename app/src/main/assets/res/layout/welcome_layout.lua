local MaterialButton = bindClass "com.google.android.material.button.MaterialButton"
local MaterialDivider = bindClass "com.google.android.material.divider.MaterialDivider"
local CircularProgressIndicator = bindClass "com.google.android.material.progressindicator.CircularProgressIndicator"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local PageView = bindClass "android.widget.PageView"
local FrameLayout = bindClass "android.widget.FrameLayout"

return
{
  CoordinatorLayout,
  h="fill",
  w="fill",
  {
    LinearLayoutCompat,
    h="fill",
    w="fill",
    orientation="vertical",
    {
      LinearLayoutCompat,
      h="fill",
      w="fill",
      orientation="vertical",
      layout_weight=1,
      gravity="center",
      {
        LinearLayoutCompat,
        w="fill",
        h="144dp",
        layout_marginTop=this.getStatusBarHeight(),
        orientation="vertical",
        gravity="center",
        layoutTransition=mTransition,
        {
          AppCompatImageView,
          w="48dp",
          padding="4dp",
          h="48dp",
          id="titleicon",
        },
        {
          AppCompatTextView,
          textSize=TextSize + 8,
          layout_marginTop="8dp",
          id="title",
          Typeface=Typeface_TTF()
        },
        {
          AppCompatTextView,
          textSize=TextSize + 1,
          layout_marginTop="8dp",
          layout_marginLeft="16dp",
          layout_marginRight="16dp",
          id="subtitle",
          gravity="center",
          Typeface=Typeface_TTF()
        },
      },
      {
        PageView,
        id="pageView",
        touchEnabled=false,
        h="fill",
        w="fill",
        layout_weight=1,
      },
    },
    {
      MaterialDivider,
      w="fill",
    },
    {
      MaterialCardView,
      h="64dp",
      w="fill",
      radius=0,
      StrokeWidth=0,
      layoutTransition=mTransition,
      id="buttonBar",
      CardBackgroundColor=0,
      {
        MaterialButton,
        textSize=TextSize,
        layout_gravity="left|center",
        paddingLeft="8dp",
        paddingRight="8dp",
        layout_marginLeft="16dp",
        layout_marginRight="16dp",
        id="previousButton",
        style=MDC_R.attr.materialButtonOutlinedStyle,
        text=res.string.step_previous,
        Typeface=Typeface_TTF()
      },
      {
        FrameLayout,
        layout_gravity="right|center",
        h="fill",
        layout_marginLeft="16dp",
        layout_marginRight="16dp",
        {
          CircularProgressIndicator,
          id="enteringProgressBar",
          Visibility=8,
          layout_gravity="center",
          Indeterminate=true,
          trackCornerRadius="2dp",
        },
        {
          MaterialButton,
          textSize=TextSize,
          layout_gravity="right|center",
          padding="16dp",
          paddingLeft="8dp",
          paddingRight="8dp",
          id="nextButton",
          text=res.string.step_next,
          Typeface=Typeface_TTF()
        },
      },
    },
  },
}