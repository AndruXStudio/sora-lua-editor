local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialButton = bindClass "com.google.android.material.button.MaterialButton"
local SwipeRefreshLayout = bindClass "androidx.swiperefreshlayout.widget.SwipeRefreshLayout"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"
local DrawableUtil = require "mods.utils.DrawableUtil"

return {
  SwipeRefreshLayout;
  id="pull_my",
  h="fill",
  w="fill",
  {
    NestedScrollView,
    h="fill",
    w="fill",
    {
      LinearLayoutCompat,
      w="fill",
      h="fill",
      {
        MaterialCardView,
        layout_marginTop="0dp",
        StrokeWidth=0,
        radius=0,
        w="fill",
        id="login",
        {
          LinearLayoutCompat,
          layout_margin="22dp",
          gravity="center",
          w="fill",
          h="fill",
          layoutTransition=mTransition,
          {
            MaterialCardView,
            StrokeWidth=0,
            radius="360dp",
            CardBackgroundColor="0xFFE0E0E0",
            Alpha=0.3,
            w="70dp",
            h="70dp",
            id="logo2",
            layoutTransition=mTransition,
            {
              AppCompatImageView,
              w="fill",
              h="fill",
              id="logo",
              ColorFilter=Colors.colorOutline;
              ImageResource=R.drawable.avatar_placeholder
            },
          },
          {
            LinearLayoutCompat,
            w="fill",
            h="fill",
            gravity="center|left",
            layout_marginLeft="16dp",
            layout_weight=1,
            orientation="vertical",
            layoutTransition=mTransition,
            {
              AppCompatTextView,
              layout_marginBottom="2dp",
              Typeface=Typeface_TTF(2),
              textSize=TextSize + 6,
              text=res.string.no_login,
              id="name",
            },
            {
              AppCompatTextView,
              layout_marginTop="2dp",
              Typeface=Typeface_TTF(),
              text=res.string.no_login_tip,
              textSize=TextSize,
              id="sign",
            },
          },
          {
            MaterialButton,
            Icon=DrawableUtil("ic_drive_file_rename_outline",Colors.colorPrimary, 24),
            Typeface=Typeface_TTF(),
            IconPadding="6dp",
            Visibility=8,
            text=res.string.check_in,
            style=MDC_R.attr.materialButtonOutlinedStyle,
          }
        },
      },
    },
  }
}