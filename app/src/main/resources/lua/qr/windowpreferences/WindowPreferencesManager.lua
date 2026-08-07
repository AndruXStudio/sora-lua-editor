local bindClass = luajava.bindClass

local Context = bindClass "android.content.Context"
local SharedPreferences = bindClass "android.content.SharedPreferences"
local Configuration = bindClass "android.content.res.Configuration"
local VERSION = bindClass "android.os.Build$VERSION"
local VERSION_CODES = bindClass "android.os.Build$VERSION_CODES"
local Window = bindClass "android.view.Window"
local WindowInsets = bindClass "android.view.WindowInsets"
local OnApplyWindowInsetsListener = bindClass "androidx.core.view.OnApplyWindowInsetsListener"
local ViewCompat = bindClass "androidx.core.view.ViewCompat"
local EdgeToEdgeUtils = bindClass "com.google.android.material.internal.EdgeToEdgeUtils"
local Force = require "qr.core.Force"

local _M = {}
local PREFERENCES_NAME = "window_preferences"
local KEY_EDGE_TO_EDGE_ENABLED = "edge_to_edge_enabled"
local context, listener;

local WindowPreferencesManager = function(_context)
  context = _context
  listener = function(v, insets)
    if v.getResources().getConfiguration().orientation
      != Configuration.ORIENTATION_LANDSCAPE then
      return insets;
    end
    if VERSION.SDK_INT >= (Force.get(VERSION_CODES, "R") or 0) then
      v.setPadding(
      insets.getInsets(WindowInsets.Type.systemBars()).left,
      0,
      insets.getInsets(WindowInsets.Type.systemBars()).right,
      insets.getInsets(WindowInsets.Type.systemBars()).bottom);
     else
      v.setPadding(
      insets.getStableInsetLeft(),
      0,
      insets.getStableInsetRight(),
      insets.getStableInsetBottom());
    end
    return insets
  end
  return _M
end

_M.toggleEdgeToEdgeEnabled = function() 
  _M.getSharedPreferences()
  .edit()
  .putBoolean(KEY_EDGE_TO_EDGE_ENABLED, !_M.isEdgeToEdgeEnabled())
  .commit();
end

_M.isEdgeToEdgeEnabled = function()
  return _M.getSharedPreferences()
  .getBoolean(KEY_EDGE_TO_EDGE_ENABLED, VERSION.SDK_INT >= (Force.get(VERSION_CODES, "R") or 0) )
end

_M.applyEdgeToEdgePreference = function(window)
  EdgeToEdgeUtils.applyEdgeToEdge(window, _M.isEdgeToEdgeEnabled())
  ViewCompat.setOnApplyWindowInsetsListener(
  window.getDecorView(), _M.isEdgeToEdgeEnabled() and listener or nil)
end

_M.getSharedPreferences = function() 
  return context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)
end

return WindowPreferencesManager