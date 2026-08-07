local ContentFrameLayout = bindClass "androidx.appcompat.widget.ContentFrameLayout"
local PhotoView = bindClass "com.load.LuaAppX.widget.PhotoView"
local FloatingActionButton = bindClass "com.google.android.material.floatingactionbutton.FloatingActionButton"
local ColorStateList = bindClass "android.content.res.ColorStateList"

return {
  ContentFrameLayout,
  id="bg",
  backgroundColor="0xFF888888",
  w="fill",
  h="fill",
  {
    PhotoView,
    w="fill",
    h="fill",
    id="mPhotoView",
    Zoomable=true,
  },
  {
    FloatingActionButton,
    id="switchBg",
    ImageDrawable=res.drawable.ic_sync,
    layout_gravity="bottom|end",
    layout_marginEnd="16dp",
    layout_marginBottom="16dp",
  },
}