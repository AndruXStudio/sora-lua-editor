local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local ListView = bindClass "android.widget.ListView"
local TextInputView = require "mods.view.TextInputView"

return {
  LinearLayoutCompat,
  orientation="vertical",
  layoutTransition=mTransition,
  {
    TextInputView.TextInputLayout,
    hint="String",
    layout_margin="26dp",
    layout_marginBottom="8dp",
    w="fill",
    {
      TextInputView.TextInputEditText,
      id="file_name",
      singleLine=true,
      w="fill"
    },
  },
  {
    ListView,
    layout_width="fill",
    id="listview2",
    DividerHeight=0,
    FastScrollEnabled=false,
    VerticalScrollBarEnabled=false,
    HorizontalScrollBarEnabled=false;
  },
}