local bindClass = luajava.bindClass
local MDC_R = bindClass "com.google.android.material.R"
local MaterialColors = bindClass "com.google.android.material.color.MaterialColors"
local Force = require "qr.core.Force"
local get = Force.get
local this = this

local DEFAULT_STATE = android.R.attr.state_enabled

local getAttr = function(name)
  return get(MDC_R.attr, name) or get(android.R.attr, name)
end

return setmetatable({}, {
  __index = (lambda (self, key) :
  get(MaterialColors, key)
  or
  MaterialColors.getColor(this, getAttr(key), DEFAULT_STATE))
})