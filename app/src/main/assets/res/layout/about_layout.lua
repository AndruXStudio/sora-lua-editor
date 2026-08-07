local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local CollapsingToolbarLayout = bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local ColorStateList = bindClass "android.content.res.ColorStateList"

return {
  CoordinatorLayout,
  w="fill",
  h="fill",
  {
    AppBarLayout,
    w="fill",
    {
      CollapsingToolbarLayout,
      w="fill",
      h="160dp",
      CollapsedTitleTextSize=dp2px(TextSize + 8),
      CollapsedTitleTypeface=Typeface_TTF(),
      ExpandedTitleTextSize=dp2px(TextSize + 12),
      ExpandedTitleTypeface=Typeface_TTF(),
      layout_scrollFlags=3,
      backgroundColor=Colors.colorBackground,
      {
        MaterialToolbar,
        backgroundColor=Colors.colorBackground,
        layout_collapseMode="pin",
        h="64dp",
        w="fill",
        id="toolbar",
      },
    },
  },
  {
    NestedScrollView,
    h="fill",
    w="fill",
    layout_behavior="appbar_scrolling_view_behavior",
    layoutTransition=mTransition,
    {
      LinearLayoutCompat,
      orientation="vertical",
      w="fill",
      h="fill",
      {
        LinearLayoutCompat,
        w="fill",
        h="fill",
        {
          MaterialCardView,
          w="fill",
          layout_margin="20dp",
          clickable=true,
          StrokeColor=colorSurfaceVariant,
          CardBackgroundColor=0,
          RippleColor=ColorStateList.valueOf(colorRipple),
          {
            LinearLayoutCompat,
            orientation="vertical",
            gravity="center",
            w="fill",
            h="fill",
            {
              AppCompatImageView,
              h="80dp",
              w="80dp",
              src="icon.png",
              padding="8dp",
              layout_margin="15dp",
              layout_marginBottom="0dp",
            },
            {
              AppCompatTextView,
              text=res.string.app_name,
              textSize=TextSize + 3,
              Typeface=Typeface_TTF(1),
              gravity="center",
              layout_margin="8dp",
              layout_marginBottom="0dp",
              textColor=Colors.colorOnBackground,
            },
            {
              AppCompatTextView,
              text=res.string.for_faster_mobile_development,
              gravity="center",
              Typeface=Typeface_TTF(),
              textSize=TextSize,
              layout_marginTop="8dp",
              layout_margin="15dp",
              textColor=Colors.colorOutline,
            },
          },
        },
      },
      {
        RecyclerView,
        h="fill",
        w="fill",
        id="recyclerView",
      },
    },
  }
}