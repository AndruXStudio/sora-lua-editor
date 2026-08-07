require "environment"
local View = bindClass "android.view.View"
local WindowManager = bindClass "android.view.WindowManager"
local Color = bindClass "android.graphics.Color"
local GlideUtil = require "mods.utils.GlideUtil"

local path = ...

try

  local window = activity.getWindow()
  window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
  window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
  | View.SYSTEM_UI_FLAG_LAYOUT_STABLE |View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
  window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
  window.setStatusBarColor(Color.TRANSPARENT);
  window.addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);

end

this {
  ContentView = res.view.photo_layout
}

mPhotoView.enable()
mPhotoView.enableRotate()
mPhotoView.setAnimaDuring(500)
mPhotoView.setAdjustViewBounds(true)

GlideUtil.setImage(path, mPhotoView)

local i = 1
local colors = {
  0xFF363636,
  0xFF888888,
  0xFFCCCCCC,
  0xFFFFFFFF,
  0xFF000000,
}

switchBg.onClick = function()
  bg.setBackgroundColor(colors[i])
  i = i % #colors + 1
end