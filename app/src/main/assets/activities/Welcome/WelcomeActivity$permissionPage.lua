local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local StaggeredGridLayoutManager = bindClass "androidx.recyclerview.widget.StaggeredGridLayoutManager"
local PackageManager = bindClass "android.content.pm.PackageManager"
local PermissionUtil = require "activities.Welcome.WelcomeActivity$1"
local SettingsLayUtil = require "mods.utils.SettingsLayUtil"

local permissionInformation={
  {
    icon="ic_insert_drive_file",
    title=res.string.storage,
    summary=res.string.storage_tips,
    permissions={"android.permission.WRITE_EXTERNAL_STORAGE","android.permission.READ_EXTERNAL_STORAGE"},
  },
  {
    icon="ic_android",
    title=res.string.install_application,
    summary=res.string.install_application_tips,
    permissions={"android.permission.REQUEST_INSTALL_PACKAGES"},
  },
}

return
{
  title=res.string.permission_request,
  icon="ic_account_key_outline",
  subtitle=res.string.permission_tips,
  key="LastActionBarElevation_permissionPage",
  layout={
    LinearLayoutCompat,
    w="fill",
    h="fill",
    orientation="vertical",
    {
      RecyclerView,
      h="fill",
      w="fill",
      id="recyclerView",
    },
  },
  onInitLayout=function(self)
    
    local recyclerView=self.recyclerView
    local function onItemClick(view,views,key,data)
      PermissionUtil.request(data.permissions)
    end
  
    table.insert(permissionInformation,{
      icon="ic_check_all",
      title=res.string.permission_requestAll,
      summary=res.string.permission_requestAll_tips,
      permissions=luajava.astable(activity.getPackageManager().getPackageInfo(activity.getPackageName(),PackageManager.GET_PERMISSIONS).requestedPermissions),
    })
  
    for index,content ipairs(permissionInformation)
      content[1]=SettingsLayUtil.ITEM
    end
  
    local adp = SettingsLayUtil.newAdapter(permissionInformation,onItemClick)
    recyclerView.setAdapter(adp)
    
    local layoutManager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
    recyclerView.setLayoutManager(layoutManager)
    
  end,
}