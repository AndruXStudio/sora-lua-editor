local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local SubtitleCollapsingToolbarLayout = luajava.bindClass "com.google.android.material.appbar.SubtitleCollapsingToolbarLayout"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local TabLayout = bindClass "com.google.android.material.tabs.TabLayout"
local CircularProgressIndicator = bindClass "com.google.android.material.progressindicator.CircularProgressIndicator"
local FrameLayout = bindClass "android.widget.FrameLayout"
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
      SubtitleCollapsingToolbarLayout,
      w="fill",
      id="u",
      h="160dp",
      CollapsedTitleTextSize=dp2px(TextSize + 8),
      CollapsedSubtitleTextSize=dp2px(TextSize + 1),
      CollapsedTitleTypeface=Typeface_TTF(),
      CollapsedSubtitleTypeface=Typeface_TTF(),
      ExpandedTitleTextSize=dp2px(TextSize + 12),
      ExpandedSubtitleTextSize=dp2px(TextSize + 2),
      ExpandedTitleTypeface=Typeface_TTF(),
      ExpandedSubtitleTypeface=Typeface_TTF(),
      layout_scrollFlags=3,
      ExpandedTitleMarginStart="18dp",
      ExpandedTitleMarginBottom="12dp",
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
    {
      TabLayout,
      TabMode=0,
      id="tab",
      w="fill",
    },
    {
      TextInputView.TextInputLayout,
      hint="String",
      layout_margin="20dp",
      layout_marginTop="8dp",
      layout_marginBottom="8dp",
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
  }
}