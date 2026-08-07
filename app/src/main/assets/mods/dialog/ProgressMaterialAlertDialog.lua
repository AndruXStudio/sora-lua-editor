local _M={}
local dialog
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local WindowManager = bindClass "android.view.WindowManager"

_M.show=function()

  dialog = dialog.show()
  
  local window = dialog.create().getWindow()
  local layoutParams = WindowManager.LayoutParams()
  layoutParams.copyFrom(window.getAttributes())
  layoutParams.width = dp2px(200)
  layoutParams.height = dp2px(315)
  dialog.show().getWindow().setAttributes(layoutParams)
  
  return _M
end

_M.dismiss=function()

  dialog.dismiss()
  
  return _M
end

setmetatable(_M,{
  __index = lambda(self,...):dialog[...]
})

return function(...)

  dialog = MaterialAlertDialog(...)
  
  .setView(res.view.progress_layout)

  return _M
end