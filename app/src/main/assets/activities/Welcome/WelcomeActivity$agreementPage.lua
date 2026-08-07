local MovementMethodUtil = bindClass "com.load.LuaAppX.utils.MovementMethodUtil"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local FastScrollScrollView = bindClass "me.zhanghai.android.fastscroll.FastScrollScrollView"
local FastScrollerBuilder = bindClass "me.zhanghai.android.fastscroll.FastScrollerBuilder"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialCheckBox = bindClass "com.google.android.material.checkbox.MaterialCheckBox"
local Html = bindClass "android.text.Html"

local function toboolean(value)
  if value
    return true
   else
    return false
  end
end

return function(title,icon,name,date)
  return {
    title=title,
    icon=icon,
    layout={
      LinearLayoutCompat,
      w="fill",
      h="fill",
      orientation="vertical",
      {
        FastScrollScrollView,
        h="fill",
        w="fill",
        layout_weight=1,
        id="scrollView",
        fillViewport=true,
        {
          AppCompatTextView,
          padding="16dp",
          id="textView",
          textSize=TextSize,
          h="fill",
          w="fill",
          textIsSelectable=true,
          linksClickable=true,
          textColor=Colors.colorOnBackground,
          Typeface=Typeface_TTF(),
          movementMethod=MovementMethodUtil.getInstance(),
        },
      },
      {
        MaterialCheckBox,
        text=(res.string.agreement_checkBox):format(title),
        id="checkBox",
        textSize=TextSize,
        w="fill",
        h="48dp",
        layout_marginRight="16dp",
        layout_marginLeft="16dp",
        Typeface=Typeface_TTF()
      },
    },
    onInitLayout=function(self)

      local textView,checkBox,scrollView = self.textView,self.checkBox,self.scrollView

      textView.setText(Html.fromHtml(io.open(activity.getLuaDir(("activities/Welcome/agreements/%s.html"):format(name))):read("*a")))

      local contrast="LastActionBarElevation_"..name
      _G[contrast]=0
      self.elevationKey = contrast

      local agree = toboolean(this.getSharedData(name) == date)
      self.allowNext = agree

      checkBox.setChecked(agree)
      checkBox.setOnCheckedChangeListener({onCheckedChanged=function()
          self:refresh()
      end})

      FastScrollerBuilder(scrollView).useMd2Style().build()

    end,

    refresh = function(self)

      local checkBox = self.checkBox
      local checked = checkBox.checked
      self.allowNext = checked

      if checked
        nextButton.setEnabled(true)
        this.setSharedData(name, date)
       else
        nextButton.setEnabled(false)
        this.setSharedData(name, nil)
      end

    end,
  }
end