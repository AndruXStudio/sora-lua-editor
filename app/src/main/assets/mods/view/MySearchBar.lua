local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local Class = require "modules.class"

return Class {

  extends = LinearLayoutCompat,

  constructor = function()
    return Layout.inflate(res.layout.searchbar_layout, LinearLayoutCompat)
  end,

  methods = {

    function setHint(self, text)
      self.getChildAt(0).getChildAt(0).getChildAt(1).setHint(text)
    end,

    function getText(self, text)
      return self.getChildAt(0).getChildAt(0).getChildAt(1).getText()
    end,

    function getView(self, text)
      return self.getChildAt(0).getChildAt(0).getChildAt(1)
    end,

  }

}