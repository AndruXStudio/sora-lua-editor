local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local Class = require "modules.class"

return Class {

  extends = LinearLayoutCompat,

  constructor = function()
    return Layout.inflate(res.layout.herobutton_layout, LinearLayoutCompat)
  end,

  methods = {

    function setIcon(self, src)
      self.getChildAt(0).getChildAt(0).setImageDrawable(src)
    end,

    function setText(self, text)
      self.getChildAt(1).setText(string.upper(text))
    end,

    function setColor(self, color)
      self.getChildAt(0).getChildAt(0).setColorFilter(color)
      self.getChildAt(1).setTextColor(color)
    end,

  }

}