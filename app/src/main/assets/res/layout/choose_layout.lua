local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local BottomSheetDragHandleView = bindClass "com.google.android.material.bottomsheet.BottomSheetDragHandleView"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"

return {
  LinearLayoutCompat,
  orientation="vertical",
  h="fill",
  w="fill",
  {
    BottomSheetDragHandleView,
    w="fill",
  },
  {
    RecyclerView,
    w="fill",
    h="fill",
    id="mRecycler",
  },
}