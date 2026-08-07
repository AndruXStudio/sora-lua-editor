local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local ColorStateList = bindClass "android.content.res.ColorStateList"
local MaterialButton = bindClass "com.google.android.material.button.MaterialButton"
local SeekBar = bindClass "android.widget.SeekBar"
local TextInputView = require "mods.view.TextInputView"

return {
  LinearLayoutCompat,
  orientation="vertical",
  w="fill",
  h="fill",
  layoutTransition=mTransition,
  {
    TextInputView.TextInputLayout,
    hint="String",
    layout_margin="26dp",
    layout_marginBottom="8dp",
    w="fill",
    {
      TextInputView.TextInputEditText,
      id="fld",
      w="fill"
    },
  },
  {
    LinearLayoutCompat,
    layout_marginLeft="26dp",
    layout_marginRight="26dp",
    layout_marginTop="6dp",
    w="fill";
    Visibility=8,
    gravity="center",
    id="root",
    {
      MaterialButton,
      text="-",
      id="fldb1",
      h="50dp",
      w="60dp",
      textSize=TextSize + 1,
      onClick=function()

        fld.setText(tostring(tointeger(string.sub(fld.Text, 1, -3))-1) .. tostring(string.sub(fld.Text, -2, -1)))
  
        return true

      end,
    },
    {
      SeekBar,
      layout_weight=1,
      Progress=10,
      Max=100,
      id="flds",
      w="fill",
    };
    {
      MaterialButton,
      text="+",
      id="fldb2",
      h="50dp",
      w="60dp",
      textSize=TextSize + 1,
      onClick=function()
        
        fld.setText(tostring(tointeger(string.sub(fld.Text, 1, -3)) + 1) .. tostring(string.sub(fld.Text, -2, -1)))
       
        return true
        
      end,
    },
  };
}