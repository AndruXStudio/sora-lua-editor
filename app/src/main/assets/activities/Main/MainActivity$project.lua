local _M = {}
local LuaRecyclerAdapter = require "LuaRecyclerAdapter"
local jpairs = require "jpairs"
local GlideUtil = require "mods.utils.GlideUtil"
local BottomSheetDialog = require "mods.dialog.BottomSheetDialog"
local SdkUtil = require "mods.utils.SdkUtil"
local DrawableUtil = require "mods.utils.DrawableUtil"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local ProgressMaterialAlertDialog = require "mods.dialog.ProgressMaterialAlertDialog"
local EditorTool = require "activities.Editor.EditorActivity$1"

local init = function()

  adapter = LuaRecyclerAdapter(data, res.layout.project_item,
  {
    onBindViewHolder = function(viewHolder, pos, views, currentData)

      local path = currentData.path

      if this.getSharedData("show_item_icon")

        GlideUtil.setImage(currentData.icon, views.icon)

       else

        views.icon2.setText(utf8.sub(currentData.appname, 1, 1))

      end

      views.appname.setText(currentData.appname)

      views.packagename.setText(currentData.packagename)

      views.appver.setText(tostring(currentData.appver))

      views.card.onClick = function()

        if File(path).isDirectory()

          ActivityUtil.new("Editor", { path })

         else

          MyToast(res.string.no_project)

        end

      end

      views.card.setOnLongClickListener(this.onLongClickX(function()

        local appsdk = currentData.appsdk
        local info = SdkUtil.getVersion(appsdk)

        local Long_dialog = BottomSheetDialog.showDialog(res.view.project_long)

        if this.getSharedData("show_item_icon")

          GlideUtil.setImage(currentData.icon, icon2)

         else

          icon3.setText(utf8.sub(currentData.appname, 1, 1))

        end

        appname2.setText(currentData.appname)

        packagename2.setText(currentData.packagename)

        prefVersion.setSubTitle(currentData.appver .. " (" .. currentData.appcode .. ")")

        prefSdk.setSubTitle(appsdk .. " [ Android: " .. info.version .. " (" .. info.codename .. ") ]")

        perfPermission.setSubTitle(tostring(table.size(currentData.user_permission)))

        perfPath.setSubTitle(currentData.path)

        build.onClick = function()

          Long_dialog.dismiss()

          ActivityUtil.new("Bin", { currentData.path })

        end

        backup.onClick = function()

          Long_dialog.dismiss()

          local Awaiting = ProgressMaterialAlertDialog(this).show()

          this.newTask(function(path, MyToast, BackupTool)

            MyToast(BackupTool(path))

            end,function()

            Awaiting.dismiss()

          end).execute({path, MyToast, EditorTool.backup})

        end

        share.onClick = function()

          Long_dialog.dismiss()

          local Awaiting = ProgressMaterialAlertDialog(this).show()

          this.newTask(function(this, path, BackupTool)

            local s = BackupTool(path)

            if s:find("：")

              this.shareFile(string.match(s, "：(.+)"))

            end

            end,function()

            Awaiting.dismiss()

          end).execute({this, path, EditorTool.backup})

        end

        delete.onClick = function()

          Long_dialog.dismiss()

          MaterialAlertDialog(this)
          .setTitle(res.string.delete)
          .setMessage((res.string.ok_delete_no):format(currentData.appname))
          .setPositiveButton(res.string.ok, function()

            local Awaiting = ProgressMaterialAlertDialog(this).show()

            this.newTask(function(path, PathUtil, MyToast, res)

              local LuaFileUtil = require "mods.utils.LuaFileUtil"
              local File = luajava.bindClass "java.io.File"

              if LuaFileUtil.remove(path)

                try
                LuaFileUtil.remove(PathUtil.cache_dir .. "/" .. File(path).getName())
              end

              MyToast(res.string.remove_ok)

             else

              MyToast(res.string.remove_no)

            end

            end,function()

            _M.updata()

            Awaiting.dismiss()

          end).execute({path, PathUtil, MyToast, res})

        end)
        .setNegativeButton(res.string.no,nil)
        .show()


      end

      return true

    end))

  end
})

end

local setAdapter = function()

  local StaggeredGridLayoutManager = bindClass "androidx.recyclerview.widget.StaggeredGridLayoutManager"

  project_rv
  .setAdapter(adapter)
  .setLayoutManager(StaggeredGridLayoutManager(ProjectListMode, StaggeredGridLayoutManager.VERTICAL))

  pull_project.setRefreshing(false)

end

_M.getProjectList = function(str)

  data = {}

  if not File(PathUtil.project_dir).canRead()

    return

  end

  local list = File(PathUtil.project_dir).list()

  for k,v jpairs(list)

    local fullPath = PathUtil.project_dir .. "/" .. v

    if File(fullPath).isDirectory() and (File(fullPath .. "/config.json").isFile() or File(fullPath .. "/init.lua").isFile())

      local icon = fullPath .. "/icon.png"

      local e, info = dofile2(fullPath)

      if e

        local appname = info.label or "UNKNOWN"

        local packagename = info.package or "UNKNOWN"

        if not str str = "" end

        if string.find(appname, str) or string.find(packagename, str)

          table.insert(data,{
            path = fullPath,
            icon = (function if File(icon).isFile() return icon else return this.getLuaDir("icon.png") end end)(),
            appname = appname,
            packagename = packagename,
            appver = info.versionName or "UNKNOWN",
            appcode = info.versionCode or "UNKNOWN",
            appsdk = info.targetSdkVersion or "UNKNOWN",
            user_permission = info.user_permission or {}
          })

        end

      end

    end

  end

  table.sort(data, function(a, b)

    return a.appname < b.appname

  end)

  init()

  setAdapter()

end

_M.updata = function()

  _M.getProjectList(tostring(search.getText()))

  pull_project.setRefreshing(false)

end

_M.onCreate = function()

  _M.updata()

  pull_project.setColorSchemeColors({Colors.colorPrimary})

  pull_project.onRefresh=function()

    _M.updata()

  end

end

return _M