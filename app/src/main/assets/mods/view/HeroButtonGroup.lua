local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local Class = require "modules.class"

return Class {

  extends = LinearLayoutCompat,

  constructor = function()
  
    return Layout.inflate({
    LinearLayoutCompat,
    backgroundColor=0
   }, LinearLayoutCompat)
   
  end,

  methods = {

  }

}