local _M = {}
local TextUtils = bindClass "android.text.TextUtils"
local ColorDrawable = bindClass "android.graphics.drawable.ColorDrawable"
local ActionMode = bindClass "androidx.appcompat.view.ActionMode"
local MotionEvent = bindClass "android.view.MotionEvent"
local Build = bindClass "android.os.Build"
local LuaFileUtil = require "mods.utils.LuaFileUtil"
local PathManagerUtil = require "mods.utils.PathManagerUtil"
local TabUtil = require "mods.utils.TabUtil"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local MagnifierManager = require "mods.utils.MagnifierManager"
local _M1 = require "mods.utils.EditorUtil$1"

local function getActionMode(view)

  return ActionMode.Callback{
    onCreateActionMode=function(mode,menu)

      _clipboardActionMode = mode
      mode.setTitle(android.R.string.selectTextMode)
      local array = activity.getTheme().obtainStyledAttributes({
        android.R.attr.actionModeSelectAllDrawable,
        android.R.attr.actionModeCutDrawable,
        android.R.attr.actionModeCopyDrawable,
        android.R.attr.actionModePasteDrawable
      })

      menu.add(0,0,0,android.R.string.selectAll)
      .setShowAsAction(2)
      .setIcon(array.getResourceId(0,0))

      menu.add(0,1,0,android.R.string.cut)
      .setShowAsAction(2)
      .setIcon(array.getResourceId(1,0))

      menu.add(0,2,0,android.R.string.copy)
      .setShowAsAction(2)
      .setIcon(array.getResourceId(2,0))

      menu.add(0,3,0,android.R.string.paste)
      .setShowAsAction(2)
      .setIcon(array.getResourceId(3,0))

      array.recycle()

      return true
    end,

    onActionItemClicked=function(mode,item)

      switch(item.getItemId())

       case 0 then
        view.selectAll()

       case 1 then
        view.cut()
        mode.finish()

       case 2 then
        view.copy()
        mode.finish()

       case 3 then
        view.paste()
        mode.finish()

      end
      return false
    end,

    onDestroyActionMode=function(mode)

      view.selectText(false)
      _clipboardActionMode=nil

    end,
  }
end

local function ChangeTitle(path)

  try

    local e, info = dofile2(luaproject)

    this
    .getSupportActionBar()
    .setTitle(setFontSize(TypefaceString(info.label or "UNKNOWN"), TextSize + 8))

    catch

    this.setTitle(setFontSize(TypefaceString(res.string.app_name),TextSize + 8))

  end

  this.getSupportActionBar().setSubtitle(setFontSize(TypefaceString(File(path).getName(), 3), TextSize + 3))

end

local function initTab()

  mTab.addOnTabSelectedListener({
    onTabUnselected = function(tab)

      _M.save()

    end,
    onTabSelected = function(tab)

      local path = tab.tag
      _M.load(path)

    end
  })

end

_M.getError = function()

  local src = mLuaEditor.getText()
  local src = src.toString()

  if (PathUtil.this_file):find("%.aly$")

    src = "return " .. src

  end

  local _, data = loadstring(src)

  if data

    local _, _, line, data = data:find(".(%d+).(.+)")
    mLuaEditor.gotoLine(tonumber(line))

    return line .. "：" .. data

   else

    return true

  end
end

_M.init = function(path)

  initTab()

  mLuaEditor
  .setBasewordColor(this.getSharedData("baseword_color"))
  .setKeywordColor(this.getSharedData("keyword_color"))
  .setCommentColor(this.getSharedData("comment_color"))
  .setUserwordColor(this.getSharedData("userword_color"))
  .setStringColor(this.getSharedData("string_color"))
  .setBackground(ColorDrawable(Colors.colorBackground))
  .setTextColor(Colors.colorOnBackground)
  .setTypeface(Typeface_TTF())
  .setTextSize(46)

  if this.getSharedData("editor_completing_box")

    mLuaEditor.autoComplete = true

   else

    mLuaEditor.autoComplete = false

  end

  mLuaEditor.setEnableDrawingErrMsg(this.getSharedData("editor_code_parser"))

  mLuaEditor.setTextSize(this.getSharedData("font_size") or 46)

  mLuaEditor.setNonPrintingCharVisibility(this.getSharedData("editor_showBlankChars") or false)

  mLuaEditor.setWordWrap(this.getSharedData("editor_wordwrap") or false)

  try

    if tonumber(Build.VERSION.RELEASE) > 9

      MagnifierManager.initMagnifier(mLuaEditor)

    end

  end

  mLuaEditor.OnSelectionChangedListener = function(status, start, end_)

    _M1.javaClassAnalyse(mLuaEditor, status)

    if not(_clipboardActionMode) and status

      this.startSupportActionMode(getActionMode(mLuaEditor))

      MagnifierManager.Available = true

     elseif _clipboardActionMode and not(status)

      _clipboardActionMode.finish()
      _clipboardActionMode = nil

      MagnifierManager.hide()
      MagnifierManager.Available = false

    end
  end

  mLuaEditor.onTouch = function(view, event)

    try

      if this.getSharedData("editor_magnify") and tonumber(Build.VERSION.RELEASE) > 9

        if MagnifierManager.Available == true

          local action = event.action

          if action == MotionEvent.ACTION_DOWN or action == MotionEvent.ACTION_MOVE

            local relativeCaretX = view.getCaretX()-view.getScrollX()
            local relativeCaretY = view.getCaretY()-view.getScrollY()
            local x = event.getX()
            local y = event.getY()

            if MagnifierManager.isNearChar(view, relativeCaretX, relativeCaretY, x, y)
              MagnifierManager.show(view, relativeCaretX, relativeCaretY, x, y)
             else
              MagnifierManager.hide()
            end

           elseif action == MotionEvent.ACTION_CANCEL or action == MotionEvent.ACTION_UP
            MagnifierManager.hide()

          end
        end
      end

    end

  end

  thread(function(this, mLuaEditor)

    local jpairs = require "jpairs"

    local LuaActivity = luajava.bindClass "com.androlua.LuaActivity"

    local act={}
    local tmp={}

    for k,v jpairs(LuaActivity.getMethods())

      v=v.getName()

      if not v:find("%$")

        if not tmp[v]

          tmp[v]=true
          act[#act+1] = v.."()"

        end

      end
    end

    classes = require "activities.JavaApi.PublicClasses"

    local ms = {
      "onCreateonCreate","onStart","onResume",
      "onPause","onStop","onDestroy","onError",
      "onActivityResult","onResult","onNightModeChanged",
      "onContentChanged","onConfigurationChanged",
      "onContextItemSelected","onCreateContextMenu",
      "onCreateOptionsMenu","onOptionsItemSelected","onRequestPermissionsResult",
      "onClick","onTouch","onLongClick",
      "onItemClick","onItemLongClick","onVersionChanged","this","android",
    }


    local custom_syntax_highlighting = this.getSharedData("custom_syntax_highlighting")

    for v custom_syntax_highlighting:gmatch("[^\n]+")

      table.insert(ms, v)

    end

    local l = #ms

    local match = string.match

    for k, v ipairs(classes)

      ms[l + k] = match(v, "%w+$")

    end

    mLuaEditor.addNames(ms)
    .addPackage("activity",act)
    .addPackage("this",act)
    .addPackage("debug",{"debug","gethook","getinfo","getlocal","getmetatable","getregistry","getupvalue","getuservalue","sethook","setlocal","setmetatable","setupvalue","setuservalue","traceback","upvalueid","upvaluejoin"})
    .addPackage("coroutine",{"create","resume","running","status","wrap","yield"})
    .addPackage("math",{"abs","acos","asin","atan","atan2","ceil","cos","cosh","deg","exp","floor","fmod","frexp","huge","ldexp","log","max","min","modf","pi","pow","rad","random","randomseed","sin","sinh","sqrt","tan","tanh"})
    .addPackage("string",{"byte","char","dump","find","format","gfind","gmatch","gsub","len","lower","match","pack","rep","reverse","sub","toutf8","unpack","upper"})
    .addPackage("utf8",{"byte","char","find","format","gfind","gmatch","gsub","len","lower","match","rep","reverse","sub","upper"})
    .addPackage("bit32",{"arshift","band","bnot","bor","btest","bxor","extract","lrotate","lshift","replace","rrotate","rshift"})
    .addPackage("table",{"add","clear","clone","concat","const","copy","dump","find","foreach","foreachi","gfind","insert","pack","remove","size","sort","sub","unpack"})
    .addPackage("os",{"clock","date","difftime","execute","exit","getenv","remove","rename","setlocale","time","tmpname"})
    .addPackage("file",{"exists","info","list","mkdir","readall","save","type"})
    .addPackage("json",{"decode","encode"})
    .addPackage("res",{"bitmap","dimen","drawable","font","layout","string","view",})
    .addPackage("luajava",{"astable","bindClass","createProxy","instanceof","loadLib","new","newInstance"})
    .addPackage("io",{"close","flush","input","lines","open","output","popen","read","tmpfile","type","write"})
    .addPackage("R",{"anim","attr","color","drawable","string","style","xml"})
    .addNames({"byte","boolean","short","int","long","float","double","char",
      "dp2px","px2dp","px2sp","sp2px",
      "Theme_Blue","Theme_Green","Theme_Yellow","Theme_Purple","Theme_Pink","Theme_Orange","Theme_Red",
      "Theme_Material3_Green","Theme_Material3_Green_Dark","Theme_Material3_Green_NoActionBar","Theme_Material3_Green_Dark_NoActionBar","ThemeOverlay_Green_MediumContrast","ThemeOverlay_Green_HighContrast",
      "Theme_Material3_Red","Theme_Material3_Red_Dark","Theme_Material3_Red_NoActionBar","Theme_Material3_Red_Dark_NoActionBar","ThemeOverlay_Red_MediumContrast","ThemeOverlay_Red_HighContrast",
      "Theme_Material3_Pink","Theme_Material3_Pink_Dark","Theme_Material3_Pink_NoActionBar","Theme_Material3_Pink_Dark_NoActionBar","ThemeOverlay_Pink_MediumContrast","ThemeOverlay_Pink_HighContrast",
      "Theme_Material3_Orange","Theme_Material3_Orange_Dark","Theme_Material3_Orange_NoActionBar","Theme_Material3_Orange_Dark_NoActionBar","ThemeOverlay_Orange_MediumContrast","ThemeOverlay_Orange_HighContrast",
      "Theme_Material3_Blue","Theme_Material3_Blue_Dark","Theme_Material3_Blue_NoActionBar","Theme_Material3_Blue_Dark_NoActionBar","ThemeOverlay_Blue_MediumContrast","ThemeOverlay_Blue_HighContrast",
      "Theme_Material3_Purple","Theme_Material3_Purple_Dark","Theme_Material3_Purple_NoActionBar","Theme_Material3_Purple_Dark_NoActionBar","ThemeOverlay_Purple_MediumContrast","ThemeOverlay_Purple_HighContrast",
      "Theme_Material3_Brown","Theme_Material3_Brown_Dark","Theme_Material3_Brown_NoActionBar","Theme_Material3_Brown_Dark_NoActionBar","ThemeOverlay_Brown_MediumContrast","ThemeOverlay_Brown_HighContrast",
    })
  end,this, mLuaEditor)

  return _M

end

local BackupFile = function(path, content)

  LuaFileUtil.checkBackup()

  local _path = path:gsub(PathUtil.project_dir, "")
  local backups = PathUtil.media_backup .. "/" .. os.date("%Y-%m-%d") .. "/" .. os.date("%H_%M") .. _path
  local backup_file = File(backups)

  if not backup_file.exists()

    File(backup_file.getParent()).mkdirs()

    LuaFileUtil.create(backups, content)

  end

end

_M.save = function()

  local path = PathUtil.this_file

  history[path] = mLuaEditor.getSelectionEnd()

  LuaFileUtil.write(luahist, string.format("history=%s", dump(history)))

  local str = mLuaEditor.getText().toString()

  if this.getSharedData("code_save_exception_detection")

    if str == ""

      MaterialAlertDialog(this)
      .setTitle(res.string.tip)
      .setMessage((res.string.null_detection_code):format(path))
      .setPositiveButton(res.string.save, function()

        LuaFileUtil.write(path , "")

        BackupFile(path, str)

      end)
      .setNegativeButton(res.string.no, nil)
      .show()

      return

    end

  end

  LuaFileUtil.write(path , str)

  BackupFile(path, str)

end

_M.load = function(path)

  PathManagerUtil.update_this_file(path)

  PathManagerUtil.update_this_dir(path:match("^(.-)/[^/]+$"))

  ChangeTitle(path)

  TabUtil.add(path)

  mLuaEditor.setText(LuaFileUtil.read(path))

  if history[path]
    mLuaEditor.setSelection(history[path])
  end

  table.insert(history, 1,path)

  for n = 2, #history

    if n > 50

      history[n] = nil

     elseif history[n] == path

      table.remove(history, n)

    end

  end

  LuaFileUtil.write(luaconf, string.format("luapath=%q", path))

  _M.fromRecy = nil

  return _M

end

_M.reopen = function(path)

  local f = io.open(path, "r")

  if f

    local str = f:read("*all")

    if tostring(mLuaEditor.getText()) ~= str

      mLuaEditor.setText(str, true)

    end

    f:close()

  end

end

return _M