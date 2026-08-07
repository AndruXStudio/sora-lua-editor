require "environment"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local SimpleMenuPopupWindow = bindClass "concerrox.ripple.menu.SimpleMenuPopupWindow"
local AppCompatDelegate = bindClass "androidx.appcompat.app.AppCompatDelegate"
local DynamicColors = bindClass "com.google.android.material.color.DynamicColors"
local SettingsLayUtil = require "mods.utils.SettingsLayUtil"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local PluginsUtil = require "mods.utils.PluginsUtil"
local ColorUtil = require "mods.utils.ColorUtil"
local ActivityUtil = require "mods.utils.ActivityUtil"
local data = require "activities.Setting.SettingActivity$data"

PluginsUtil.clearOpenedPluginPaths()
PluginsUtil.setActivityName("SettingActivity")

this {
  Title = res.string.setting,
  ContentView = res.view.setting_layout,
  SupportActionBar = toolbar
}
.getSupportActionBar()
{
  DisplayHomeAsUpEnabled = true
}

onOptionsItemSelected = function(v)

  if v.getItemId() == android.R.id.home

    finish()

  end

end

local custom = function(action, title, message)

  MaterialAlertDialog(this)
  .setTitle(title)
  .setMessage(message)
  .setView(res.view.dialog_fileinput)
  .setPositiveButton(res.string.ok, function()

    this.setSharedData(action, tostring(file_name.getText()))

    adapter.notifyDataSetChanged()

  end)
  .setNegativeButton(res.string.no)
  .show()

  file_name.setText(this.getSharedData(action))

end

local Simple_Pop = function(view, key, item, w, callback)

  local data = {}

  for k,v ipairs(item)
    table.insert(data, setFontSize(TypefaceString(v), TextSize + 2))
  end


  menu = SimpleMenuPopupWindow(activity)
  .setOnItemClickListener(function(i)

    try

      view.getChildAt(1).getChildAt(1).setText(item[i + 1])

      catch

      view.getChildAt(0).getChildAt(1).setText(item[i + 1])

    end

    menu.setSelectedIndex(i)
    this.setSharedData(key, i + 1)

    try callback(i + 1) end

  end)
  .setEntries(data)
  .show(view, view.getParent(), w)
  .setSelectedIndex(this.getSharedData(key) - 1 or 0)

end

local onItemClick = function(view, views, key, data)

  local action = data.action

  if key == "eyedropper_variant" or key == "slide_hide" or key == "show_item_icon"

    this.result {}

   elseif key == "theme_light_dark"

    Simple_Pop(view, key, data.items, dp2px(70), function(i)

      AppCompatDelegate.setDefaultNightMode((function() switch i case 1 return -1 case 2 return 2 case 3 return 1 end end)())

    end)

   elseif key == "item_list_columns" or key == "theme_color" or key == "global_font_size"

    Simple_Pop(view, key, data.items, dp2px(70), function(i)

      this.result {}

    end)

   elseif key == "layouthelper_dialog" or key == "signature_scheme"

    Simple_Pop(view, key, data.items, dp2px(70))

   elseif key == "about"

    ActivityUtil.new("About")

   elseif key == "plugins_manager"

    ActivityUtil.new("Plugins")

   elseif key == "clear_data"

    MaterialAlertDialog(this)
    .setTitle(res.string.tip)
    .setMessage(res.string.clear_data_tip2)
    .setPositiveButton(res.string.ok,{onClick=function()

        os.execute("pm clear "..activity.getPackageName())

    end})
    .setNegativeButton(res.string.no)
    .show()

   elseif action == "custom_symbol_bar"

    custom(action, data.title, res.string.custom_symbol_bar_tip)

   elseif action == "custom_syntax_highlighting"

    custom(action, data.title, res.string.custom_syntax_highlighting_tip)

   elseif action == "keyword_color" or action == "userword_color" or action == "baseword_color" or action == "string_color" or action == "comment_color"

    ColorUtil.setPalette(this.getSharedData(action), function(color)

      if color:find("0x") and color:match("^0x%x+$")

        this.setSharedData(action, tonumber(color))

        adapter.notifyDataSetChanged()

      end

    end)

  end

  PluginsUtil.callElevents("onItemClick", views, key, data)

end

for index, content ipairs(data)

  if content.title == res.string.plugins

    local items = {}

    PluginsUtil.callElevents("onLoadItemsList",items)

    for index2, content in ipairs(items)

      table.insert(data, index + index2, content)

    end

    break

  end

end

adapter = SettingsLayUtil.newAdapter(data,onItemClick)

recyclerView
.setAdapter(adapter)
.setLayoutManager(LinearLayoutManager())