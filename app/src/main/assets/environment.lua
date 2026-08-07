require "import"
bindClass = luajava.bindClass
newInstance = luajava.newInstance
res = require "mods.utils.ResUtil"
TypefaceUtil = require "mods.utils.TypefaceUtil"
Colors = require "qr.material.Colors"

local themes = {
  "Blue",
  "Green",
  "Red",
  "Orange",
  "Pink",
  "Purple",
  "Brown"
}

this.setTheme(R.style["Theme_Material3_" .. (function() return themes[this.getSharedData("theme_color")] end)() .. "_NoActionBar"])

if this.getSharedData("eyedropper_variant")

  bindClass "com.google.android.material.color.DynamicColors"
  .applyToActivityIfAvailable(this)

end

bindClass "androidx.appcompat.app.AppCompatDelegate"
.setDefaultNightMode((function()
  switch this.getSharedData("theme_light_dark")

   case 1

    if this.getResources().getConfiguration().uiMode& bindClass "android.content.res.Configuration".UI_MODE_NIGHT_YES!=0 == true
      colorRipple = 0x31FFFFFF
     else
      colorRipple = 0x31000000
    end

    return -1

   case 2

    colorRipple = 0x31FFFFFF

    return 2

   case 3

    colorRipple = 0x31000000

    return 1

  end
end)())

onError = function(err, message)

  local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"

  local err_dialog = MaterialAlertDialog(this)
  .setTitle("onError")
  .setMessage(err .. "：\n" .. tostring(message))
  .setPositiveButton(res.string.ok,nil)
  .setNegativeButton(res.string.copy,function()

    this.getSystemService("clipboard").setText(err)

  end)
  .show()

end

dofile2 = function(path)

  local File = luajava.bindClass "java.io.File"

  if File(path .. "/config.json").isFile()

    e, s = pcall(dofile, path .. "/config.json")
    if !s return false end

    return true, {
      label = s.label,
      package = s.package,
      versionName = s.versionName,
      versionCode = s.versionCode,
      minSdkVersion = s.minSdkVersion,
      targetSdkVersion = s.targetSdkVersion,
      debugmode = s.debugmode,
      debuggermode = s.debuggermode,
      user_permission = s.user_permission,
      skip_compilation = s.skip_compilation
    }

   elseif File(path .. "/init.lua").isFile()

    e, s = pcall(dofile, path .. "/init.lua")
    if !e return false end

    return true, {
      label = appname,
      package = packagename,
      versionName = appver,
      versionCode = appcode,
      minSdkVersion = "23",
      targetSdkVersion = appsdk,
      debugmode = debugmode,
      debuggermode = debuggermode,
      user_permission = user_permission,
      skip_compilation = skip_compilation
    }

  end

end

MyToast = require "mods.utils.ToastUtil"
PathUtil = require "mods.utils.PathUtil"
MDC_R = bindClass "com.google.android.material.R"
mTransition = bindClass "android.animation.LayoutTransition"().enableTransitionType(4)
Layout = require "mods.utils.LayoutUtil"

local UiUtil = require "mods.utils.UiUtil"
local WindowManager = bindClass "android.view.WindowManager"
local View = bindClass "android.view.View"

local window = activity.getWindow()
window.setSoftInputMode(0x10)
.setStatusBarColor(Colors.colorBackground)
.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)

if UiUtil.isNightMode()
  window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)
 else
  window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
end

function finish()

  this.finish()

end

onKeyDownX(function()
  finish()
end)