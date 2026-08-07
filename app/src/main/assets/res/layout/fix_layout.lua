local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local CollapsingToolbarLayout = bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local CircularProgressIndicator = bindClass "com.google.android.material.progressindicator.CircularProgressIndicator"
local FrameLayout = bindClass "android.widget.FrameLayout"

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
    FrameLayout,
    h="fill",
    w="fill",
    layoutTransition=mTransition,
    layout_behavior="appbar_scrolling_view_behavior",
    {
      RecyclerView,
      h="fill",
      w="fill",
      id="recyclerView",
    },
    {
      CircularProgressIndicator,
      id="progressView",
      layout_gravity="center",
      indeterminate=true,
      indicatorSize="55dp",
      trackCornerRadius="5dp",
      trackThickness="5dp"
    },
  }
}