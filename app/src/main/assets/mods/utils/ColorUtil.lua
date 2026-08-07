local _M = {}
local ColorStateList = bindClass "android.content.res.ColorStateList"
local Configuration = bindClass "android.content.res.Configuration"
local ProgressDrawable = bindClass "com.scwang.smartrefresh.layout.internal.ProgressDrawable"
local PorterDuffColorFilter = bindClass "android.graphics.PorterDuffColorFilter"
local PorterDuff = bindClass "android.graphics.PorterDuff"
local GradientDrawable = bindClass "android.graphics.drawable.GradientDrawable"
local Color = bindClass "android.graphics.Color"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"

_M.getRipple = function(code, color)

  local attrs = { code and android.R.attr.selectableItemBackground or android.R.attr.selectableItemBackgroundBorderless }
  local ripple = this.obtainStyledAttributes(attrs).getResourceId(0,0)

  local drawable = this.Resources.getDrawable(ripple)
  drawable.setColor(ColorStateList.valueOf(color or colorRipple))

  return drawable

end

local CircleButtom = function(view, insideColor)

  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(insideColor)
  drawable.setCornerRadii({360, 360, 360, 360, 360, 360, 360, 360})
  view.setBackgroundDrawable(drawable)

end

local arba = function(color)

  local a = tostring(Color.alpha(color))
  local r = tostring(Color.red(color))
  local g = tostring(Color.green(color))
  local b = tostring(Color.blue(color))

  return string.format("0x%02x%02x%02x%02x",a,r,g,b)

end

_M.setPalette = function(color, callback)

  local color = color and arba(color)

  local ColorPaletteDialog = MaterialAlertDialog(this)
  .setTitle(res.string.colorpalette)
  .setView(res.view.colorpalette_layout)
  .setPositiveButton(color and res.string.ok or res.string.copy,function()

    callback(mmp4.Text)

  end)
  .setNegativeButton(res.string.no)
  .show()

  function setSeekBarProgress(seekBar, textView, color)
    seekBar.setMax(255)
    seekBar.setProgress(0)
    seekBar.ProgressDrawable.setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
    seekBar.Thumb.setColorFilter(PorterDuffColorFilter(color,PorterDuff.Mode.SRC_ATOP))
    seekBar.setOnSeekBarChangeListener{
      onProgressChanged = function(SeekBar, progress)

        progress = progress + 1
        local hexColor = string.format("%02X", progress - 1)
        textView.setText(hexColor)
        local d = mmp6.getText()..mmp1.getText()..mmp2.getText()..mmp3.getText()
        mmp4.setText("0x"..d)
        local ys = int("0x"..d)
        CircleButtom(mmp5, ys)

      end
    }
  end

  setSeekBarProgress(seek_Ap, mmp6, Colors.colorOnBackground)
  setSeekBarProgress(seek_red, mmp1, 0xFFFF0000)
  setSeekBarProgress(seek_green, mmp2, 0xFF00FF00)
  setSeekBarProgress(seek_blue, mmp3, 0xFF0000FF)

  if color

    seek_Ap.setProgress(tonumber(string.sub(color,3,4), 16))

    seek_red.setProgress(tonumber(string.sub(color,5,6), 16))

    seek_green.setProgress(tonumber(string.sub(color,7,8), 16))

    seek_blue.setProgress(tonumber(string.sub(color,9,10), 16))

  end

end

return _M