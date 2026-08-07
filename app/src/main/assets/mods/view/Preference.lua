local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local Class = require "modules.class"

return Class {

  extends = LinearLayoutCompat,

  constructor = function()
    return Layout.inflate(res.layout.preference_layout, LinearLayoutCompat)
  end,

  methods = {

    function setTitle(self, text)
      self.getChildAt(0).getChildAt(1).getChildAt(0).setText(text)
    end,

    function setSubTitle(self, text)
      self.getChildAt(0).getChildAt(1).getChildAt(1).setText(text)
    end,

    function setIcon(self, src)
      self.getChildAt(0).getChildAt(0).setImageDrawable(src)
    end,

    function setIconColor(self, color)
      self.getChildAt(0).getChildAt(0).setColorFilter(color)
    end,

  }

}