local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local ListView = bindClass "android.widget.ListView"
local BottomSheetDragHandleView = bindClass "com.google.android.material.bottomsheet.BottomSheetDragHandleView"

return {
  LinearLayoutCompat,
  orientation="vertical",
  h="fill",
  w="fill",
  gravity="center",
  id="mViewParent",
  {
    BottomSheetDragHandleView,
    w="fill",
  },
  {
    AppCompatTextView,
    layout_marginBottom="16dp",
    Typeface=Typeface_TTF(2),
    textColor=Colors.colorPrimary,
    textSize=TextSize + 4,
    id="mDialogTitle"
  },
  {
    function(v)
      return BottomSheetDialog.prepareListView(ListView(v))
    end,
    layout_marginLeft="15dp",
    layout_marginRight="15dp",
    layout_marginBottom="15dp",
    w="fill",
    clipToPadding=false,
    nestedScrollingEnabled=true,
    id="mDialogListView",
  }
}