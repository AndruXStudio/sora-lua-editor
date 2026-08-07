local _M = {}
local AppCompatDialog = bindClass "androidx.appcompat.app.AppCompatDialog"
local LuaEditor = bindClass "com.androlua.LuaEditor"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialButton = bindClass "com.google.android.material.button.MaterialButton"
local MaterialDivider = bindClass "com.google.android.material.divider.MaterialDivider"
local ColorDrawable = bindClass "android.graphics.drawable.ColorDrawable"

t={
  LinearLayoutCompat,
  id="l",
  orientation="vertical" ,
  {
    LuaEditor,
    id="edit",
    w="fill",
    h="fill",
    layout_weight=1,
  },
  {
    MaterialDivider,
    w="fill",
  },
  {
    LinearLayoutCompat,
    w="fill",
    layout_marginLeft="12dp",
    layout_marginRight="12dp",
    {
      MaterialButton,
      id="open1",
      textSize=TextSize + 1,
      text=res.string.preview,
      Typeface=Typeface_TTF(),
      w="fill",
      layout_weight=1,
      layout_margin="4dp"
    } ,
    {
      MaterialButton,
      id="open2",
      textSize=TextSize + 1,
      Typeface=Typeface_TTF(),
      text=res.string.copy,
      w="fill",
      layout_weight=1,
      layout_margin="4dp"
    } ,
    {
      MaterialButton,
      id="open3",
      textSize=TextSize + 1,
      Typeface=Typeface_TTF(),
      text=res.string.ok,
      w="fill",
      layout_weight=1,
      layout_margin="4dp"
    } ,
  }
}

_M.Layout_preview = function(s)

  dlg=luajava.override(AppCompatDialog,{
    onMenuItemSelected=function(super,id,item)

      dlg.dismiss()

  end}, this, this.getThemeResId())
  dlg.setTitle(res.string.layout_preview)
  dlg.setContentView(loadlayout(loadstring("return "..s)(),{}))
  dlg.show()

end

_M.Layout_edit = function(txt)

  dlg2=luajava.override(AppCompatDialog,{
    onMenuItemSelected=function(super,id,item)
      dlg2.dismiss()
  end}, this, this.getThemeResId())

  dlg2.setTitle(res.string.editor_code)
  dlg2.getWindow().setSoftInputMode(0x10)
  dlg2.setContentView(loadlayout(t))

  edit
  .setBasewordColor(this.getSharedData("baseword_color"))
  .setKeywordColor(this.getSharedData("keyword_color"))
  .setCommentColor(this.getSharedData("comment_color"))
  .setUserwordColor(this.getSharedData("userword_color"))
  .setStringColor(this.getSharedData("string_color"))
  .setBackground(ColorDrawable(Colors.colorBackground))
  .setTextColor(Colors.colorOnBackground)
  .setTypeface(Typeface_TTF(4))
  .setTextSize(46)
  .setText(txt)

  task(100, edit.format)

  dlg2.show()

  open1.onClick = function()

    local str = edit.getText().toString()

    _M.Layout_preview(str)

  end

  open2.onClick = function(s)

    this.getSystemService("clipboard").setText(edit.getText().toString())

    MyToast(res.string.copied)

  end

  open3.onClick = function()

    layout.main = loadstring("return " .. edit.getText().toString())()

    mods.ShowLayout(loadlayout2(layout.main,{}))

    dlg2.dismiss()

  end

  return _M

end

return _M