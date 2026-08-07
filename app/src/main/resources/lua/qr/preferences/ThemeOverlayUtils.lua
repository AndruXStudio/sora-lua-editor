local bindClass = luajava.bindClass

local SparseIntArray = bindClass "android.util.SparseIntArray"
local ThemeUtils = bindClass "com.google.android.material.color.ThemeUtils"

local _M = {}
local NO_THEME_OVERLAY = 0
local themeOverlays = SparseIntArray()

_M.setThemeOverlay = function(id, themeOverlay)
  if themeOverlay == NO_THEME_OVERLAY then
    themeOverlays.delete(id)
   else
    themeOverlays.put(id, themeOverlay)
  end
end

_M.clearThemeOverlay = function(id)
  themeOverlays.delete(id)
end

_M.clearThemeOverlays = function(activity)
  themeOverlays.clear()
  activity.recreate()
end

_M.getThemeOverlay = function(id)
  return themeOverlays.get(id)
end

_M.applyThemeOverlays = function(activity)
  for i = 0, themeOverlays.size() do
    ThemeUtils.applyThemeOverlay(activity, themeOverlays.valueAt(i))
  end
end

return _M