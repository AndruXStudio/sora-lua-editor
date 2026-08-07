local _M={}
local ActivityCompat = bindClass "androidx.core.app.ActivityCompat"
local String = bindClass "java.lang.String"
local PackageManager = bindClass "android.content.pm.PackageManager"
local File = bindClass "java.io.File"
local DrawableUtil = require "mods.utils.DrawableUtil"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"

local grantedList = {}
_M.grantedList = grantedList


local request = function(permissions)
  ActivityCompat.requestPermissions(activity,String(permissions),0)
end
_M.request = request


local checkPermission = function(permission)
  return ActivityCompat.checkSelfPermission(activity,permission)==PackageManager.PERMISSION_GRANTED
end
_M.checkPermission = checkPermission


local check = function(permissions)
  for index,permission in ipairs(permissions)
    local granted = checkPermission(permission)
    if not(granted)
      return false
    end
  end
  return true
end
_M.check = check

local askForRequestPermissions = function(permissionsItemsList)
  
  for index=1, #permissionsItemsList
    
    local permissionsItem = permissionsItemsList[index]
    local permissions = permissionsItem.permissions
    if not check(permissions)
      
      local Request_Build = MaterialAlertDialog(this)
      .setTitle(res.string.permission_request)
      .setMessage(TypefaceString(res.string.app_name .. " " .. res.string.permission_ask))
      .setPositiveButton(res.string.ok,{onClick=function()
          if permissionsItem.intent
            this.startActivity(permissionsItem.intent)
           else
            request(permissions)
          end
      end})
      .setNegativeButton(res.string.no)

      local Request_Dia = Request_Build.create()
      Request_Dia.setCanceledOnTouchOutside(false)
      Request_Dia.show()

     else

      local function createDirectoryIfNotExists(path)
        local directory = File(path)
        if not directory.isDirectory()
          directory.mkdirs()
        end
      end

      createDirectoryIfNotExists(PathUtil.my_dir)
      createDirectoryIfNotExists(PathUtil.project_dir)
      createDirectoryIfNotExists(PathUtil.bin_dir)
      createDirectoryIfNotExists(PathUtil.backup_dir)
      createDirectoryIfNotExists(PathUtil.solibs_dir)
      createDirectoryIfNotExists(PathUtil.lualibs_dir)
      createDirectoryIfNotExists(PathUtil.plug_dir)
      createDirectoryIfNotExists(PathUtil.download_dir)
      createDirectoryIfNotExists(PathUtil.cache_dir)

      local binlogFile = File(PathUtil.my_dir .. "/binlog")
      
      if not binlogFile.exists()
        binlogFile.createNewFile()
      end

    end
  end
end

_M.askForRequestPermissions = askForRequestPermissions

return _M