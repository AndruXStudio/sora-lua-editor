local _M = {}
local MaterialAlertDialogBuilder = bindClass "com.google.android.material.dialog.MaterialAlertDialogBuilder"
local Build = bindClass "android.os.Build"
local DialogInterface = bindClass "android.content.DialogInterface"
local DrawableUtil = require "mods.utils.DrawableUtil"

_M.setTitle = function(str)

  dialog.setTitle(setFontSize(TypefaceString(str),TextSize + 10))

  return _M

end

_M.setMessage = function(str)

  dialog.setMessage(setFontSize(TypefaceString(str),TextSize))

  return _M
end

_M.setPositiveButton = function(str,callback)

  dialog.setPositiveButton(setFontSize(TypefaceString(str),TextSize),callback)

  return _M
end

_M.setNeutralButton = function(str,callback)

  dialog.setNeutralButton(setFontSize(TypefaceString(str),TextSize),callback)

  return _M
end

_M.setNegativeButton = function(str,callback)

  dialog.setNegativeButton(setFontSize(TypefaceString(str),TextSize),callback)

  return _M
end

_M.setView = function(layout)

  dialog.setView(layout)

  return _M
end

_M.setIcon = function(image)

  dialog.setIcon(DrawableUtil(image,Colors.colorOnSurfaceVariant))

  return _M
end

_M.setItems = function(item,callback)

  dialog.setItems(item,callback)

  return _M
end

_M.show = function()

  if this.getSharedData("dialog_box_blur")

    dialog.setOnDismissListener(DialogInterface.OnDismissListener{
      onDismiss = function()

        local decorView = this.getWindow().getDecorView()

        decorView.setRenderEffect(nil)

      end

    })

  end

  dialog = dialog.show()

  return _M
end

_M.dismiss = function()

  dialog.dismiss()

  return _M
end

setmetatable(_M,{
  __index = lambda(self,...):dialog[...]
})

return function(...)

  dialog = MaterialAlertDialogBuilder(...)

  if this.getSharedData("dialog_box_blur")

    local RenderEffect = bindClass "android.graphics.RenderEffect"

    local Shader = bindClass "android.graphics.Shader"

    local decorView = this.getWindow().getDecorView()

    decorView.setRenderEffect(RenderEffect.createBlurEffect(25, 25, Shader.TileMode.CLAMP))

  end

  return _M
end