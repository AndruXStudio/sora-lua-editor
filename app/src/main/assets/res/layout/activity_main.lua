local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local BottomNavigationView = bindClass "com.google.android.material.bottomnavigation.BottomNavigationView"
local CollapsingToolbarLayout = bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local FragmentContainerView = bindClass "androidx.fragment.app.FragmentContainerView"
local FloatingActionButton = bindClass "com.google.android.material.floatingactionbutton.FloatingActionButton"
local MySearchBar = require "mods.view.MySearchBar"

return {
  CoordinatorLayout,
  w="fill",
  h="fill",
  {
    AppBarLayout,
    w="fill",
    id="appBar",
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
    LinearLayoutCompat,
    h="fill",
    w="fill",
    orientation="vertical",
    layout_behavior="appbar_scrolling_view_behavior",
    layoutTransition=mTransition,
    {
      MySearchBar,
      id="search",
      hint=res.string.search_tip,
      w="fill",
      Visibility=8,
    },
    {
      FragmentContainerView,
      h="fill",
      w="fill",
      id="fragment",
    },
  },
  {
    BottomNavigationView,
    id="bottombar",
    layout_gravity="bottom",
    h="wrap",
    w="fill",
    LabelVisibilityMode=0,
  },
  {
    FloatingActionButton,
    id="fab",
   -- layout_behavior=FabBehavior,
    layout_gravity="end|bottom",
    ImageDrawable=res.drawable.ic_add
  },
}