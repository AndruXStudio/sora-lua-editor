local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local CollapsingToolbarLayout = bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"

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
      AppCompatTextView,
      padding="16dp",
      textSize=TextSize,
      id="textView",
      h="fill",
      w="fill",
      textIsSelectable=true,
      Typeface=Typeface_TTF(),
      textColor=Colors.colorOnBackground,
    },
  }
}