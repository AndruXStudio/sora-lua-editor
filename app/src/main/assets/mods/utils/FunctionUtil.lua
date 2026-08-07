local _M={}
local MaterialTextView = bindClass "com.google.android.material.textview.MaterialTextView"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local GradientDrawable = bindClass "android.graphics.drawable.GradientDrawable"
local PorterDuff = bindClass "android.graphics.PorterDuff"
local PorterDuffColorFilter = bindClass "android.graphics.PorterDuffColorFilter"
local ProgressDrawable = bindClass "com.scwang.smartrefresh.layout.internal.ProgressDrawable"
local ColorStateList = bindClass "android.content.res.ColorStateList"
local DrawableUtil = require "mods.utils.DrawableUtil"
local ChangeUtil = require "mods.utils.ChangeUtil"
local LuaFileUtil = require "mods.utils.LuaFileUtil"
local DialogUtil = require "mods.utils.DialogUtil"
local EditorUtil = require "mods.utils.EditorUtil"
local FileListUtil = require "activities.Editor.EditorActivity$list"
local ColorUtil = require "mods.utils.ColorUtil"

local function CircleButtom(view, insideColor)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setColor(insideColor)
  drawable.setCornerRadii({360, 360, 360, 360, 360, 360, 360, 360})
  view.setBackgroundDrawable(drawable)
end

local newDir = function(path)

  File(path).mkdirs()
  FileListUtil.updata()

end

_M.add=function(name,callback)

  function_menu_root.setVisibility(0)

  function_menu.addView(Layout.inflate({
    MaterialTextView,
    text=name,
    textColor=Colors.colorOnSurfaceVariant,
    gravity="center",
    h="fill",
    TooltipText=name,
    paddingRight="8dp",
    textSize=TextSize + 1,
    paddingLeft="8dp",
    Typeface=Typeface_TTF(),
    backgroundDrawable=ColorUtil.getRipple(),
    onClick=callback
  }))

  return _M

end

_M.OpenColorPalette=function()
  ColorUtil.setPalette(nil,function(color)
    
    this.getSystemService("clipboard").setText(color)
    
  end)
end

_M.OpenGreateDialog=function()

  MaterialAlertDialog(this)
  .setTitle(res.string.c_f_f)
  .setItems({setFontSize(TypefaceString(res.string.c_f), TextSize),setFontSize(TypefaceString(res.string.c_f2), TextSize)},function(l,v)
    if v==0

      Newdialog = MaterialAlertDialog(this)
      .setTitle(res.string.c_f)
      .setView(res.view.dialog_fileinput)
      .setPositiveButton(res.string.ok)
      .setNegativeButton(res.string.no)
      .create()

      DialogUtil.onShow(Newdialog,function()
        local new_path = PathUtil.this_dir .. "/" .. tostring(file_name.getText())

        if File(new_path).exists()
          textInput_name.setError(TypefaceString(res.string.exists_file))
          return
        end

        LuaFileUtil.create(new_path, "")
        FileListUtil.updata()
        Newdialog.dismiss()

      end)

      Newdialog.show()
      ChangeUtil.EditTextChanged({file_name}, {textInput_name})

     elseif v==1

      Newdialog = MaterialAlertDialog(this)
      .setTitle(res.string.c_f2)
      .setView(res.view.dialog_fileinput)
      .setPositiveButton(res.string.ok)
      .setNegativeButton(res.string.no)
      .create()

      DialogUtil.onShow(Newdialog,function()

        local new_path = PathUtil.this_dir .. "/" .. tostring(file_name.getText())

        if File(new_path).exists()
          textInput_name.setError(TypefaceString(res.string.exists_file))
          return
        end

        newDir(new_path)
        Newdialog.dismiss()

      end)

      Newdialog.show()
      ChangeUtil.EditTextChanged({file_name},{textInput_name})

    end
  end)
  .setPositiveButton(res.string.no,nil)
  .show()

end

_M.setHideMenu=function(boolean)

  if boolean == true

    fab1.setVisibility(8)
    fab2.setVisibility(8)
    fab3.setVisibility(8)

  end

  return _M

end

_M.getLuaPath = function()

  return PathUtil.this_file

end

_M.getLuaDir = function()

  return PathUtil.this_dir

end

_M.getProjectPath=function()

  return luaproject

end

return _M