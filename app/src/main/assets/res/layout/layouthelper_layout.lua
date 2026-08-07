local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"

return {
  LinearLayoutCompat,
  orientation="vertical",
  h="fill",
  w="fill",
  {
    AppBarLayout,
    orientation="vertical",
    h="wrap",
    w="fill",
    {
      MaterialToolbar,
      h="wrap",
      w="fill",
      id="toolbar",
      backgroundColor=Colors.colorBackground,
      layout_scrollFlags=3,
    },
  },
  {
    LinearLayoutCompat,
    w="fill",
    h="fill",
    id="Linearx",
    layoutTransition=mTransition,
  }
}