local _M={}
local ColorStateList = bindClass "android.content.res.ColorStateList"
local TextInputLayout = bindClass "com.google.android.material.textfield.TextInputLayout"
local TextInputEditText = bindClass "com.google.android.material.textfield.TextInputEditText"

_M.TextInputLayout = setmetatable({
  cls = TextInputLayout
  },{
  __call = function(self,...)
    local view = self.cls(...)
    local value = dp2px(12)
    view.setBoxCornerRadii(value,value,value,value)
    view.setEndIconTintList(ColorStateList.valueOf(Colors.colorPrimary))
    view.setStartIconTintList(ColorStateList.valueOf(Colors.colorPrimary))
    view.setBoxStrokeColor(Colors.colorPrimary)
    view.setBoxBackgroundMode(TextInputLayout.BOX_BACKGROUND_OUTLINE)
    return view
  end
})

_M.TextInputLayout2 = setmetatable({
  cls = TextInputLayout
  },{
  __call = function(self,...)
    local view = self.cls(...)
    local value = dp2px(12)
    view.setBoxCornerRadii(value,value,value,value)
    view.setEndIconTintList(ColorStateList.valueOf(Colors.colorPrimary))
    view.setStartIconTintList(ColorStateList.valueOf(Colors.colorPrimary))
    view.setBoxStrokeColor(Colors.colorPrimary)
    view.setBoxBackgroundMode(TextInputLayout.BOX_BACKGROUND_OUTLINE)
    return view
  end
})

_M.TextInputEditText = setmetatable({
  cls = TextInputEditText
  },{
  __call = function(self,...)
    local view = self.cls(...)
    local style = MDC_R.style.Widget_Material3_TextInputEditText_OutlinedBox
    local wrapper = newInstance("androidx.appcompat.view.ContextThemeWrapper",activity,style)
    local view = self.cls(wrapper,nil,style)
    view.setTypeface(Typeface_TTF())
    view.setTextSize(TextSize + 1)
    view.setTextColor(Colors.colorOnBackground)
    return view
  end
})

return _M