local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local ColorStateList = bindClass "android.content.res.ColorStateList"
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
    id="textInput_name",
    {
      TextInputView.TextInputEditText,
      id="file_name",
      --singleLine=true,
      w="fill"
    },
  },
}