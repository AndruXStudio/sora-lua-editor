require "environment"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerAdapter = bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local AdapterCreator = bindClass "com.lua.custrecycleradapter.AdapterCreator"
local PopupMenu = bindClass "androidx.appcompat.widget.PopupMenu"
local Intent = bindClass "android.content.Intent"
local Uri = bindClass "android.net.Uri"
local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
local SpannableString = bindClass "android.text.SpannableString"
local PopupMenuUtils = require "mods.utils.PopupMenuUtils"
local SettingsLayUtil = require "mods.utils.SettingsLayUtil"
local SettingsLayUtilPro = require "activities.Plugins.SettingsLayUtilPro"
local PluginsUtil = require "mods.utils.PluginsUtil"
local UiUtil = require "mods.utils.UiUtil"
local ChooseUtil = require "mods.utils.ChooseUtil"
local data = require "activities.Plugins.PluginsActivity$data"

local settings2 = {}
local PLUGINS_DIR = File(PathUtil.plug_dir)
local PackInfo = this.PackageManager.getPackageInfo(this.getPackageName(),64)
local versionCode = PackInfo.versionCode

this {
  Title = res.string.plugins_title,
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

onResume = function()

  refresh()

end

local onItemClick = function(view, views, key, data)

  if key == "plugin_item"

    local newState = data.checked

    if data.enableVer

      if newState

        PluginsUtil.setEnabled(data.dirName, versionCode)

       else

        PluginsUtil.setEnabled(data.dirName, false)

      end

     else

      PluginsUtil.setEnabled(data.dirName, newState)

    end

    this.getApplication().set("plugin_enabledpaths",nil)

   elseif key == "install_plugin"

    ChooseUtil.show(2)

   elseif key=="download_plugin"

    pcall(this.startActivity,Intent(Intent.ACTION_VIEW, Uri.parse(("mqqapi://card/show_pslcard?src_type=internal&version=1&uin=542704713&card_type=group&source=qrcode"))))

  end
end

local onItemLongClick = function(view, views, key, data)

  if key == "plugin_item"

    local config = data.config
    local pop = PopupMenu(activity,view.getChildAt(1).getChildAt(0))
    local menu = pop.Menu

    PopupMenuUtils.setHeaderTitle(pop,data.title)

    menu.add(setFontSize(TypefaceString(res.string.plugins_uninstall), TextSize + 2)).onMenuItemClick=function()

      PluginsUtil.uninstall(data.path,config,function(state)

        if state == "success"

          MyToast(res.string.uninstall_success)

          refresh()

         elseif state == "failed"

          MyToast(res.string.uninstall_failed)

        end

      end)

    end

    pop.show()

    return true

  end

end

local addSummaryTextLine = function(summarySpanIndex,color,oldSummary,summary)

  local newSummary = oldSummary.."\n"..summary

  table.insert(summarySpanIndex,{color,utf8.len(oldSummary)+1,utf8.len(newSummary)})

  return newSummary

end

local toboolean = function(value)

  if value

    return true

   else

    return false

  end

end

local adapter = LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount = function()

    return SettingsLayUtil.adapterEvents.getItemCount(settings2)

  end,

  getItemViewType = function(position)

    return SettingsLayUtil.adapterEvents.getItemViewType(settings2,position)

  end,

  onCreateViewHolder = function(parent,viewType)

    local holder = SettingsLayUtil.adapterEvents.onCreateViewHolder(onItemClick,onItemLongClick,parent,viewType)
    local ids = holder.view.tag
    local infoBtnView = ids.infoBtnView

    if infoBtnView then
      infoBtnView.setColorFilter(Colors.colorError)
      infoBtnView.setOnClickListener(onItemInfoBtnClickListener)
    end

    return holder

  end,

  onBindViewHolder = function(holder,position)

    local data = settings2[position+1]
    local layoutView = holder.view
    local ids = layoutView.getTag()
    local infoBtnView = ids.infoBtnView

    if infoBtnView then

      if data.hasReadme

        infoBtnView.setVisibility(0)

       else

        infoBtnView.setVisibility(8)

      end

      infoBtnView.tag = data

    end

    SettingsLayUtil.adapterEvents.onBindViewHolder(settings2,holder,position)

  end,
}))

refresh = function()

  table.clear(settings2)

  for index,content ipairs(data)

    table.insert(settings2,content)

  end

  if PLUGINS_DIR.isDirectory()

    local fileList = PLUGINS_DIR.listFiles()

    for index = 0,#fileList-1

      local file = fileList[index]

      if file.isDirectory()

        local title,config,spannableSummary
        local summary = ""
        local summarySpanIndex = {}
        local enableVer = false
        local checked = false
        local switchEnabled = true
        local path = file.getPath()
        local dirName = file.getName()
        local initPath = path.."/init.lua"
        local icon = path.."/icon.png"
        local icon_night = path.."/icon-night.png"

        if File(initPath).isFile()

          config = PluginsUtil.getConfigFromFile(initPath)

          if config.appname

            title = config.appname

           else

            title = dirName

          end

          local description = config.description

          if description and type(description) == "string" and description ~= ""

            summary = config.description.."\n"

          end

          local pluginVersionName = config.appver
          local pluginVersionCode = config.appcode

          if pluginVersionName

            if versionCode

              summary = summary..(res.string.plugins_info_version):format(("%s (%s)"):format(pluginVersionName,pluginVersionCode))

             else

              summary = summary..(res.string.plugins_info_version):format(pluginVersionName)

            end

           elseif pluginVersionCode

            summary = summary..(res.string.plugins_info_version):format(pluginVersionCode)

           else

            summary = summary..(res.string.plugins_info_version):format(res.string.unknown)

          end

          local packageName = config.packagename

          if packageName

            summary = summary.."\n"..(res.string.plugins_info_packageName):format(packageName)

            if packageName ~= dirName

              summary = summary.."\n"..(res.string.plugins_info_folderName):format(dirName)
              summary = addSummaryTextLine(summarySpanIndex,0xFFFF9000,summary,res.string.plugins_warning_keepPFSame)

            end

           else

            summary = summary.."\n"..(res.string.plugins_info_folderName):format(dirName)
            summary = addSummaryTextLine(summarySpanIndex,0xFFFF9000,summary,res.string.plugins_warning_addPackageName)

          end

          checked = PluginsUtil.getEnabled(dirName)

          local supports = config.supported2

          if supports

            local versionConfig = supports[res.string.app_name]

            if versionConfig

              local minVerCode = versionConfig.mincode
              local targetVerCode = versionConfig.targetcode

              if not(minVerCode) or minVerCode <= versionCode

                if targetVerCode and targetVerCode<versionCode

                  checked = checked == versionCode
                  enableVer = true
                  summary = addSummaryTextLine(summarySpanIndex,0xFFFF9000,summary,res.string.plugins_warning_supported)

                end

               else

                switchEnabled = false
                summary = addSummaryTextLine(summarySpanIndex,0xFFFF0000,summary,res.string.plugins_error_update_app)

              end

             else

              summary = addSummaryTextLine(summarySpanIndex,0xFFFF0000,summary,res.string.plugins_error_unsupported)

            end

           elseif supports == nil

            summary = addSummaryTextLine(summarySpanIndex,0xFFFF9000,summary,res.string.plugins_warning_supported)

          end

         else

          config = {}
          switchEnabled = false
          title = dirName
          summary = res.string.plugins_error

          table.insert(summarySpanIndex,{0xFFFF0000,0,utf8.len(summary)})

        end

        if #summarySpanIndex ~= 0

          spannableSummary = SpannableString(summary)
          summary = nil

          for index,content ipairs(summarySpanIndex)

            spannableSummary.setSpan(ForegroundColorSpan(content[1]),content[2],content[3],0)

          end

        end

        if UiUtil.isNightMode() and File(icon_night).isFile()

          icon = icon_night

        end

        if not(File(icon).isFile())

          icon = "ic_puzzle_outline"

        end

        table.insert(settings2,{
          (function()
            if config.smallicon
              return SettingsLayUtil.ITEM_AVATAR_ICON_SWITCH
             else
              return SettingsLayUtil.ITEM_AVATAR_SWITCH
            end
          end)(),
          icon = icon,
          title = title,
          summary = summary or spannableSummary,
          key = "plugin_item",
          checked = toboolean(checked),
          config = config,
          switchEnabled = switchEnabled,
          enableVer = enableVer,
          dirName = dirName,
          path = path,
        })

      end

    end

  end

  table.insert(settings2,{
    SettingsLayUtil.ITEM_ONLYSUMMARY,
    summary = res.string.plugins_reboot,
    clickable = false
  })

  recyclerView
  .setAdapter(adapter)
  .setLayoutManager(LinearLayoutManager())

end