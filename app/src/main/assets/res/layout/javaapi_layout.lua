local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local CollapsingToolbarLayout = bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local CircularProgressIndicator = bindClass "com.google.android.material.progressindicator.CircularProgressIndicator"
local FrameLayout = bindClass "android.widget.FrameLayout"
local FloatingActionButton = bindClass "com.google.android.material.floatingactionbutton.FloatingActionButton"
local TextInputView = require "mods.view.TextInputView"

return {
  CoordinatorLayout,
  w="fill",
  h="fill",
  {
    AppBarLayout,
    backgroundColor=Colors.colorBackground,
    w="fill",
    {
      CollapsingToolbarLayout,
      w="fill",
      h="160dp",
      backgroundColor=Colors.colorBackground,
      CollapsedTitleTextSize=dp2px(TextSize + 8),
      CollapsedTitleTypeface=Typeface_TTF(),
      ExpandedTitleTextSize=dp2px(TextSize + 12),
      ExpandedTitleTypeface=Typeface_TTF(),
      layout_scrollFlags=3,
      {
        MaterialToolbar,
        backgroundColor=Colors.colorBackground,
        layout_collapseMode="pin",
        h="64dp",
        w="fill",
        id="toolbar",
      },
    },
    {
      TextInputView.TextInputLayout,
      hint="String",
      layout_margin="20dp",
      layout_marginTop="8dp",
      id="name_root",
      w="fill",
      {
        TextInputView.TextInputEditText,
        id="name",
        singleLine=true,
        w="fill"
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
  },
  {
    FloatingActionButton,
    id="fab",
    ImageDrawable=res.drawable.ic_sync,
    layout_gravity="bottom|end",
    layout_marginEnd="16dp",
    layout_marginBottom="16dp",
  },
}