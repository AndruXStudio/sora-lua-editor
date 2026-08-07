local _M={}
local String = bindClass "java.lang.String"
local PermissionUtil = require "activities.Welcome.WelcomeActivity$1"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"

local PLUGINS_PATH = PathUtil.plug_dir
local PLUGINS_DATA_PATH = PathUtil.media .. "/data/plugins"
_M.PLUGINS_PATH = PLUGINS_PATH
_M.PLUGINS_DATA_PATH = PLUGINS_DATA_PATH
_M._VERSION="3.1.2"

function _M.callElevents(name, ...)

  if not PermissionUtil.check({
      "android.permission.WRITE_EXTERNAL_STORAGE",
      "android.permission.READ_EXTERNAL_STORAGE"
    })

    return

  end

  --if activityName
  if plugins == nil

    _M.loadPlugins()

  end

  local events = plugins.events[name]--公共事件
  local events2 = plugins.events2[name]--页面事件
  local finalResult

  if events

    for index, content ipairs(events)

      local state,result=xpcall(content, function(err)

        onPluginError(plugins.eventsName[name][index],plugins.eventsPackageName[name][index],err,name.." (Global)")

      end, activityName, ...)

      if result~=nil

        finalResult=result or finalResult

      end

    end

  end

  if events2

    for index, content ipairs(events2)

      local state,result=xpcall(content, function(err)

        onPluginError(plugins.eventsName2[name][index],plugins.eventsPackageName2[name][index],err,name)

      end, ...)

      if result~=nil

        finalResult=result or finalResult

      end

    end

  end

  return finalResult

end

function _M.clearOpenedPluginPaths()
  this.getApplication().set("plugin_enabledpaths",nil)
end

function _M.getPlugins()
  return plugins
end

function _M.setPlugins(newPlugins)
  plugins = newPlugins
  return _M
end

--设置活动标识
_M.setActivityName = function(name)
  activityName = name
  return _M
end

local function setEnabled(packageName, state)
  this.setSharedData("plugin_" .. packageName .. "_enabled", state)
  return _M
end
_M.setEnabled = setEnabled

_M.getEnabled = function(packageName)
  local state = this.getSharedData("plugin_" .. packageName .. "_enabled")
  if state == nil
    setEnabled(packageName, true)
    return true
   else
    return state or false
  end
end

--获取是不是真正启用了
local function getReallyEnabled(enabled, config)
  local supports=config.supported2
  if apptype and supports
    local versionConfig=supports[res.string.app_name]
    if versionConfig
      local minVerCode = versionConfig.mincode
      local targetVerCode = versionConfig.targetcode
      --进行版本校验
      if (minVerCode and minVerCode > versionCode) or (targetVerCode and targetVerCode < versionCode and enabled ~= versionCode)
        return false
      end
    end
  end
  return true
end
_M.getReallyEnabled = getReallyEnabled

local function getPluginPath(packageName)
  return PLUGINS_PATH .. "/" .. packageName
end
_M.getPluginPath = getPluginPath

local function getPluginDataPath(packageName)
  return PLUGINS_DATA_PATH .. "/" .. packageName
end
_M.getPluginDataPath = getPluginDataPath

--获取插件是否可用
local function getAvailable(packageName)
  local path = getPluginDataPath(packageName)
  if not (File(path).isDirectory())
    return false
  end
  return _M.getEnabled(packageName)
end
_M.getAvailable = getAvailable

--获取函数的插件事件与名字列表
function getPluginsEventsAndName(pluginsEvents, pluginsEventsName, pluginsEventsPackageName, name)
  local eventsList=pluginsEvents[name]
  local eventsNameList=pluginsEventsName[name]
  local eventsPackageNameList=pluginsEventsPackageName[name]
  if eventsList == nil
    eventsList={}
    eventsNameList={}
    eventsPackageNameList={}
    pluginsEvents[name]=eventsList
    pluginsEventsName[name]=eventsNameList
    pluginsEventsPackageName[name]=eventsPackageNameList
  end
  return eventsList, eventsNameList, eventsPackageNameList
end

local pluginEnvTable = {
  getPluginPath=getPluginPath,
  getPluginDataPath=getPluginDataPath,
}

setmetatable(pluginEnvTable,{__index=_G})

local function getConfig(configs,path)
  local config = configs[path]
  if not(config)
    config = getConfigFromFile(path .. "/init.lua") -- init.lua内容
    config.pluginPath = path
    setmetatable(config, {__index = pluginEnvTable})--设置环境变量
    configs[path]=config
  end
  return config
end

local function getConfigFromFile(path)
  local env={}
  assert(loadfile(tostring(path), "bt", env))()
  return env
end
_M.getConfigFromFile = getConfigFromFile

local function onPluginError(titleName, packageName, message, funcName)
  MaterialAlertDialog(this)
  .setTitle("Error "..titleName)
  .setMessage(message)
  .setPositiveButton(res.string.ok)
  .show()
  pcall(function()
    io.open("/sdcard/LuaAppX/crash/"..activity.getPackageName().."_"..packageName..".txt","a"):write(funcName..os.date(" %Y-%m-%d %H:%M:%S").."\n"..message.."\n\n"):close()
  end)
end

function loadPlugins ()

  if not PermissionUtil.check({
      "android.permission.WRITE_EXTERNAL_STORAGE",
      "android.permission.READ_EXTERNAL_STORAGE"
    })

    return

  end

  plugins = {}

  enabledPluginPaths = this.getApplication().get("plugin_enabledpaths")

  --enabledPluginPaths={}
  local pluginsEvents = {}
  local pluginsEventsName = {}
  local pluginsEvents2 = {}
  local pluginsEventsName2 = {}
  local pluginsEventsPackageName2 = {}
  local pluginsActivities = {}
  local pluginsActivitiesName = {}
  local configs = {}

  plugins.events = pluginsEvents
  plugins.eventsName = pluginsEventsName
  plugins.events2 = pluginsEvents2
  plugins.eventsName2 = pluginsEventsName2
  plugins.eventsPackageName2 = pluginsEventsPackageName2
  plugins.activities = pluginsActivities
  plugins.activitiesName = pluginsActivitiesName
  plugins.configs = configs

  if not(enabledPluginPaths)

    enabledPluginPaths={}

    local pluginsFile = File(PLUGINS_PATH)

    if pluginsFile.isDirectory() -- 存在插件文件夹

      local fileList = pluginsFile.listFiles()

      for index = 0, #fileList - 1

        local file = fileList[index]
        local path = file.getPath()
        local dirName = file.getName()

        local defaultEnabled = _M.getEnabled(dirName)

        if defaultEnabled -- 检测是否开启

          local initPath = path .. "/init.lua"

          if File(initPath).isFile() -- 存在init.lua

            try
              --获取config
              --下面的步骤和getConfig执行的结果完全一样，但出于性能考虑，重复写一套
              local config = getConfigFromFile(initPath) -- init.lua内容
              config.pluginPath = path
              setmetatable(config, {__index = pluginEnvTable})--设置环境变量
              configs[path]=config

              if getReallyEnabled(defaultEnabled,config)

                local err=false
                local thirdPlugins = config.thirdplugins

                if thirdPlugins--存在需要的第三方插件库

                  for index, content ipairs(thirdPlugins)

                    if not (getAvailable(content))--如果存在不可用的

                      print("Plugin", dirName, "error: Plugin", content, "not found.")
                      err = true

                    end

                  end
                end

                --没有问题
                if err == false
                  table.insert(enabledPluginPaths,path)
                end
              end

              catch(err)
              onPluginError(dirName,dirName,err,"init.lua")

            end

          end
        end
      end
    end

    enabledPluginPaths = String(enabledPluginPaths)

    this.getApplication().set("plugin_enabledpaths",enabledPluginPaths)

  end

  for index=0, #enabledPluginPaths - 1

    local path = enabledPluginPaths[index]
    local file = File(path)
    local dirName = file.getName()
    local config = getConfig(configs,path)
    local mainPath = path .. "/main.lua"
    local configDirPath = path .. "/config"
    local eventsDirPath = configDirPath .. "/events"

    local name = ("%s (%s)"):format(config.appname, config.packagename or dirName)
    local fileEvents=config.events

    if fileEvents

      for index,content pairs(fileEvents)

        local eventsList,eventsNameList,eventsPackageNameList=getPluginsEventsAndName(pluginsEvents,pluginsEventsName,pluginsEventsPackageName,index)

        table.insert(eventsList,content)
        table.insert(eventsNameList,name)
        table.insert(eventsPackageNameList,config.packagename)

      end
    end

    if activityName

      local eventsAlyPath = eventsDirPath .. "/" .. activityName .. ".lua"

      if File(eventsAlyPath).isFile()

        try

          local fileEvents = assert(loadfile(eventsAlyPath, "bt", config))()

          for index, content pairs(fileEvents)
            local eventsList,eventsNameList,eventsPackageNameList=getPluginsEventsAndName(pluginsEvents2,pluginsEventsName2,pluginsEventsPackageName2,index)

            table.insert(eventsList,content)
            table.insert(eventsNameList,name)
            table.insert(eventsPackageNameList,config.packagename)
          end

          catch(err)

          onPluginError(dirName,dirName,err,"init.lua")

        end
      end
    end

    --可以使用单独的页面打开
    if File(mainPath).isFile()

      table.insert(pluginsActivities, mainPath)
      table.insert(pluginsActivitiesName, config.appname or config.packagename or dirName)

    end
  end

  return _M
end

_M.loadPlugins = loadPlugins

_M.uninstall = function(path, config, callback)
  local dir=File(path)
  local dirName=dir.getName()
  MaterialAlertDialog(this)
  .setTitle((res.string.uninstall_withName):format(config.appname or dirName))
  .setMessage(res.string.plugins_uninstall_warning)
  .setPositiveButton(res.string.ok,function()
    if dir.exists()
      LuaUtil.rmDir(dir)
      LuaUtil.rmDir(File(getPluginDataPath(dirName)))
      setEnabled(dirName,nil)
      callback("success")
     else
      callback("failed")
    end
  end)
  .setNegativeButton(res.string.no)
  .show()
end

return _M