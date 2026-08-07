require "environment"
local ActionBarDrawerToggle = bindClass "androidx.appcompat.app.ActionBarDrawerToggle"
local SpannableString = bindClass "android.text.SpannableString"
local Typeface = bindClass "android.graphics.Typeface"
local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
local TypefaceSpan = bindClass "android.text.style.TypefaceSpan"
local Spannable = bindClass "android.text.Spannable"
local DrawableUtil = require "mods.utils.DrawableUtil"
local EditorUtil = require "mods.utils.EditorUtil"
local PluginsUtil = require "mods.utils.PluginsUtil"
local ProgressMaterialAlertDialog = require "mods.dialog.ProgressMaterialAlertDialog"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local ColorUtil = require "mods.utils.ColorUtil"
FileListUtil = require "activities.Editor.EditorActivity$list"
EditorTool = require "activities.Editor.EditorActivity$1"
ActivityUtil = require "mods.utils.ActivityUtil"

if this.getSharedData("dark_toolbar")

  colorToolBar = Colors.colorSurfaceContainer

 else

  colorToolBar = Colors.colorBackground

end

local window = activity.getWindow()
window.setSoftInputMode(0x10)
.setStatusBarColor(colorToolBar)

luaproject = ...

local cache_project = PathUtil.cache_dir.."/"..File(luaproject).getName()

if not File(cache_project).isDirectory()

  File(cache_project).mkdirs()

end

luahist = cache_project.."/.lua.hist"
luaconf = cache_project .. "/.lua.conf"
luaproj = cache_project .. "/.lua.proj"

pcall(dofile, luaconf)
pcall(dofile, luahist)

history = history or {}

if (luapath and not File(luapath).isFile()) or not luapath

  luapath2 = luaproject .. "/main.lua"

end

PathUtil.this_file = luapath or luapath2
PathUtil.this_dir = (PathUtil.this_file):match("^(.-)/[^/]+$")

PluginsUtil.clearOpenedPluginPaths()
PluginsUtil.setActivityName("EditorActivity")
PluginsUtil.loadPlugins()

this {
  ContentView = res.view.editor_layout,
  SupportActionBar = toolbar
}
.getSupportActionBar()
{
  DisplayHomeAsUpEnabled = true
}

local toggle = ActionBarDrawerToggle(this, drawer, R.string.open_drawer, R.string.close_drawer)
drawer.setDrawerListener(toggle)
toggle.syncState()

onOptionsItemSelected = function(item)

  if item.getItemId() == android.R.id.home

    if not drawer.isDrawerOpen(3)

      drawer.openDrawer(3)

     else

      drawer.closeDrawer(3)

    end

  end

  PluginsUtil.callElevents("onOptionsItemSelected", item)

end

onCreate = function(savedInstanceState)

  filetab.setPath(PathUtil.this_dir)

  mRecycler.post(function()

    FileListUtil
    .init()
    .updata()

  end)

  EditorUtil
  .init()
  .load(PathUtil.this_file)
  
  
  PluginsUtil.callElevents("onCreate", savedInstanceState)

end
onStart = function()

  EditorUtil.reopen(PathUtil.this_file)

end

onCreateOptionsMenu = function(menu)
  local menu_show = 2

  menu.add(TypefaceString(res.string.run_code))
  .setShowAsAction(menu_show)
  .setIcon(DrawableUtil("ic_play",Colors.colorOnSurfaceVariant))
  .onMenuItemClick=function()

    EditorUtil.save()

    if this.getSharedData("check_error")

      GetError = EditorUtil.getError()

     else

      GetError = true

    end

    if GetError == true

      this.newActivity(luaproject .. "/main.lua")

     else

      MyToast(GetError)

    end

  end

  menu.add(TypefaceString(res.string.undo))
  .setShowAsAction(menu_show)
  .setIcon(DrawableUtil("ic_undo",Colors.colorOnSurfaceVariant))
  .onMenuItemClick=function()

    mLuaEditor.undo()

  end

  menu.add(TypefaceString(res.string.redo))
  .setShowAsAction(menu_show)
  .setIcon(DrawableUtil("ic_redo",Colors.colorOnSurfaceVariant))
  .onMenuItemClick=function()

    mLuaEditor.redo()

  end

  local menu0 = menu.addSubMenu(setFontSize(TypefaceString(res.string.file .. "…"),TextSize + 2))
  menu0.add(setFontSize(TypefaceString(res.string.compilation),TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()
    import "console"

    local path,str = console.build(PathUtil.this_file)

    if path

      MyToast(res.string.compilation_ok..". ".. path)

     else

      MyToast(res.string.compilation_no..". " .. str)

    end

    FileListUtil.updata()

  end

  menu0.add(setFontSize(TypefaceString(res.string.history_record),TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()

    local history_dialog = MaterialAlertDialog(this)
    .setTitle(res.string.history_record)
    .setView(res.view.history_layout)
    .setPositiveButton(res.string.ok)
    .show()

    local plist = history

    local adapter = function(data)

      local adapter = LuaAdapter(this, res.layout.history_item)

      listview2.setAdapter(adapter)

      for k, v ipairs(data)

        adapter.add{

          text = string.match(v, luaproject .. "%/(.+)"),

        }

      end

    end


    adapter(history)

    file_name.addTextChangedListener {
      onTextChanged = function(c)

        local s = tostring(c)

        if #s == 0

          adapter(plist)

        end

        local t = {}

        s = s:lower()

        for k, v ipairs(plist)

          if v:lower():find(s, 1, true)

            table.insert(t, v)

          end

        end

        adapter(t)

      end

    }

    listview2.setOnItemClickListener(bindClass "android.widget.AdapterView".OnItemClickListener {
      onItemClick = function(parent, v, pos, id)

        EditorUtil.load(luaproject .. "/" .. v.Tag.text.Text)

        history_dialog.dismiss()

      end
    })

  end

  local menu1 = menu.addSubMenu(setFontSize(TypefaceString(res.string.project .. "…"), TextSize + 2))
  menu1.add(setFontSize(TypefaceString(res.string.backup),TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()

    local Awaiting = ProgressMaterialAlertDialog(this).show()

    this.newTask(function(path, MyToast, BackupTool)

      MyToast(BackupTool(path))

      end,function()

      Awaiting.dismiss()

    end).execute({luaproject, MyToast, EditorTool.backup})

  end

  menu1.add(setFontSize(TypefaceString(res.string.projectinfo),TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()

    ActivityUtil.new("ProjectInfo",{ luaproject })

  end

  local menu2 = menu.addSubMenu(setFontSize(TypefaceString(res.string.code .. "…"), TextSize + 2))
  menu2.add(setFontSize(TypefaceString(res.string.check_error),TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()

    local GetError = EditorUtil.getError()

    if GetError == true

      MyToast(res.string.no_error)

     else

      MyToast(GetError)

    end
  end
  menu2.add(setFontSize(TypefaceString(res.string.search),TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()
    mLuaEditor.search()

  end

  menu2.add(setFontSize(TypefaceString(res.string.analysis_import), TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()
    ActivityUtil.new("Fix",{ PathUtil.this_file })

  end

  local menu3 = menu.addSubMenu(setFontSize(TypefaceString(res.string.tools .. "…"), TextSize + 2))
  menu3.add(setFontSize(TypefaceString(res.string.logs), TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()
    ActivityUtil.new("Logs")

  end
  menu3.add(setFontSize(TypefaceString(res.string.api_title), TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()
    ActivityUtil.new("JavaApi")

  end

  menu3.add(setFontSize(TypefaceString(res.string.layout_helper), TextSize + 2)).onMenuItemClick=function()

    EditorUtil.save()
    ActivityUtil.new("LayoutHelper",{
      luaproject,
      PathUtil.this_file
    })

  end

  PluginsUtil.callElevents("onCreateOptionsMenu", menu)

end

swipeRefresh.setColorSchemeColors({Colors.colorPrimary})

swipeRefresh.onRefresh=function()

  FileListUtil.updata()

end

onPause = function()

  EditorUtil.save()

end

onResult = function(name,str)

  local name = File(name).Name

  if name == "ProjectInfoActivity"

    this.getSupportActionBar().setTitle(setFontSize(TypefaceString(str), TextSize + 9))

    MyToast(res.string.now_save)

    EditorUtil.load(PathUtil.this_file)

   elseif name == "LayoutHelperActivity"

    if str == true

      task(100,mLuaEditor.format)

      MyToast(res.string.now_save)

     else

      MaterialAlertDialog(this)
      .setTitle(res.string.tip)
      .setMessage(str)
      .setPositiveButton(res.string.ok)
      .show()

    end

  end

  PluginsUtil.callElevents("onResult", name, str)

end

onActivityResult = function(req, resx, intent)
  if resx ~= 0

    local data = intent.getStringExtra("data")
    local _, _, path, line = data:find("\n[	 ]*([^\n]-):(%d+):")
    local classes = require "activities.JavaApi.PublicClasses"
    local c = data:match("a nil value %(global '(%w+)'%)")

    if c

      local cls = {}
      c = "%." .. c .. "$"

      for k, v ipairs(classes)

        if v:find(c)



          table.insert(cls,setFontSize(TypefaceString(v),TextSize))

        end

      end

      if #cls > 0

        MaterialAlertDialog(this)
        .setTitle(res.string.fix_title)
        .setItems(cls,{onClick=function(l,v)

            local content = tostring(cls[v+1])

            this.getSystemService("clipboard").setText("import " .. "\"" .. content .. "\"")

        end})
        .setPositiveButton(res.string.ok, nil)
        .show()

      end
    end
  end

  PluginsUtil.callElevents("onActivityResult",req, resx, intent)

end

local Creat_Shortcut_Symbol_Bar = function(id)

  local MaterialTextView = bindClass "com.google.android.material.textview.MaterialTextView"
  local symbol_text = this.getSharedData("custom_symbol_bar") or [[Fun() ( ) [ ] { } \ : . , ; _ + - * / \ % # ^ $ ? & | < > ~ ' ]]

  for v in symbol_text:gmatch("%S+")
    local Item = {
      MaterialTextView,
      layout_height="45dp",
      gravity="center",
      textColor=Colors.colorOnBackground,
      text=tostring(v),
      paddingRight="12dp",
      paddingLeft="12dp",
      textSize=TextSize + 1,
      Typeface=Typeface_TTF(),
      clickable=true,
      id="symbol",
      backgroundDrawable=ColorUtil.getRipple(),
      singleLine=true,
    }
    id.addView(loadlayout(Item))

    symbol.onClick = function(v)

      local v = v.getText()

      if v == "←"
        mLuaEditor.setSelection(mLuaEditor.getSelectionStart() - 1)
       elseif v == "→"
        mLuaEditor.setSelection(mLuaEditor.getSelectionStart() + 1)
       elseif v == "Fun()"
        mLuaEditor.paste("function")
       elseif v == "↹"
        mLuaEditor.paste("\t")
       elseif v == "对齐" or v == "格式化" or v == "代码对齐"
        mLuaEditor.format()
       else
        mLuaEditor.paste(v)
      end

    end

    symbol.setOnLongClickListener(this.onLongClickX(function(v)

      local v = v.getText()

      if v == "Fun()"
        mLuaEditor.paste("function ()\nend")
       elseif v == "↹"
        mLuaEditor.paste("\t\t")
       elseif v == "("
        mLuaEditor.paste("()")
       elseif v == "←"
        mLuaEditor.setSelection(tonumber(mLuaEditor.getCaretPosition() - 2))
       elseif v == "→"
        mLuaEditor.setSelection(tonumber(mLuaEditor.getCaretPosition() + 2))
       elseif v == "\""
        mLuaEditor.paste("\"\"")
       elseif v == "["
        mLuaEditor.paste("[]")
       elseif v == "{"
        mLuaEditor.paste("{}")
       elseif v == "="
        mLuaEditor.paste("==")
       elseif v == "."
        mLuaEditor.paste("..")
       elseif v == ","
        mLuaEditor.paste(",,")
       elseif v == "-"
        mLuaEditor.paste("--")
       elseif v == "<"
        mLuaEditor.paste("<=")
       elseif v == ">"
        mLuaEditor.paste(">=")
       elseif v == "~"
        mLuaEditor.paste("~=")
       elseif v == "!"
        mLuaEditor.paste("!=")
       elseif v == "'"
        mLuaEditor.paste("''")
       else
        mLuaEditor.paste(v..v)
      end

      return true

    end))

  end

end

if this.getSharedData("editor_symbolBar")

  task(100,Creat_Shortcut_Symbol_Bar(ps_bar))

end

onKeyDownX(function()

  if drawer.isDrawerOpen(3)

    drawer.closeDrawer(3)

   else

    EditorUtil.save()

    finish()

  end

end)