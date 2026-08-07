local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"

return {
  NestedScrollView,
  w="fill",
  h="fill",
  {
    LinearLayoutCompat,
    w="fill",
    h="fill",
    orientation="vertical",
  }
}