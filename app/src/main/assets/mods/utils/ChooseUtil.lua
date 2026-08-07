local _M = {}
local AnimatorSet = bindClass "android.animation.AnimatorSet"
local ObjectAnimator = bindClass "android.animation.ObjectAnimator"
local DecelerateInterpolator = newInstance "android.view.animation.DecelerateInterpolator"
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local PopupRecyclerAdapter = bindClass "github.znzsofficial.adapter.PopupRecyclerAdapter"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local Runtime = bindClass "java.lang.Runtime"
local Executors = bindClass "java.util.concurrent.Executors"
local HandlerCompat = bindClass "androidx.core.os.HandlerCompat"
local Looper = bindClass "android.os.Looper"
local mainLooper = Looper.getMainLooper()
local handler = HandlerCompat.createAsync(mainLooper)
local executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors())
local GlideUtil = require "mods.utils.GlideUtil"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local ProgressMaterialAlertDialog = require "mods.dialog.ProgressMaterialAlertDialog"
local BottomSheetDialog = require "mods.dialog.BottomSheetDialog"
local json = require "json"

local getalpinfoplug = function(path)

  try

  local config = {}

  loadstring(tostring(String(LuaUtil.readZip(path , "init.lua"))), "bt", "bt", config)()

  return true, config

  catch(e)

  return false, e

end

end

local getalpinfoalp = function(path)

  local e,s = pcall(LuaUtil.readZip, path , "config.json")

  if e

    return true, json.decode(tostring(String(s)))

   else
   
    local e , s = pcall(LuaUtil.readZip, path , "init.lua")

    if e
      
      local config = {}
      
      loadstring(tostring(String(s)), "bt", "bt", config)()

      return true, {
        label = config.appname,
        package = config.packagename,
        versionName = config.appver,
        versionCode = config.appcode
        }
      
     else

      MaterialAlertDialog(this)
      .setTitle(res.string.tip)
      .setMessage(e .. "\n" .. res.string.config_json_not_found)
      .setPositiveButton(res.string.ok)
      .show()

      return false

    end

  end

end

_M.Import = function(path)


  if index == 1

    local success, config = getalpinfoalp(path)

    if success

      local appname = config.label
      local packagename = config.package
      local str = string.format(res.string.name .. "：%s\
".. res.string.appver .. "： %s\
".. res.string.appcode .. "：%s\
".. res.string.package .. "：%s\
".. res.string.path .. "：%s",
      appname,
      config.versionName,
      config.versionCode,
      packagename,
      path)

      Import_dialog = MaterialAlertDialog(this)
      .setTitle(res.string.import_source)
      .setMessage(str)
      .setPositiveButton(res.string.import_text,function()

        local vpath = PathUtil.project_dir .. "/" .. appname

        if File(vpath).exists()

          Import_dialog.dismiss()

          MaterialAlertDialog(this)

          .setTitle(res.string.tip)
          .setMessage((res.string.import_ok_no):format(appname))
          .setPositiveButton(res.string.ok,function()

            Import_dialog.dismiss()

            local Awaiting = ProgressMaterialAlertDialog(this).show()

            this.newTask(function(path, vpath, MyToast, res)

              local ZipUtil = luajava.bindClass "com.androlua.ZipUtil"

              if ZipUtil.unzip(path, vpath .. "_Cover" .. "/")

                MyToast(res.string.import_ok)

               else

                MyToast(res.string.import_no)

              end

              end,function()

              try ProjectFragment.updata() end

            Awaiting.dismiss()

          end).execute({path, vpath, MyToast, res})

        end)
        .setNegativeButton(res.string.no)
        .show()

       else

        Import_dialog.dismiss()

        local Awaiting = ProgressMaterialAlertDialog(this).show()

        this.newTask(function(path, vpath, MyToast, res)

          local ZipUtil = luajava.bindClass "com.androlua.ZipUtil"

          if ZipUtil.unzip(path, vpath .. "/")

            MyToast(res.string.import_ok)

           else

            MyToast(res.string.import_no)

          end

          end,function()

          try ProjectFragment.updata() end

        Awaiting.dismiss()

      end).execute({path, vpath, MyToast, res})

    end

  end)
  .setNegativeButton(res.string.no)
  .show()

end

elseif index == 2

local success, config = getalpinfoplug(path)

if success

  if not (config.mode == "plugin")

    MyToast(res.string.no_plug)

    return

  end

  local packagename = config.packagename
  local str = string.format(res.string.name .. "：%s\
".. res.string.appver .. "：%s\
".. res.string.package .. "：%s\
".. res.string.author .. "：%s\
".. res.string.explanation .. "：%s\
".. res.string.path .. "：%s",
  config.appname,
  config.appver,
  packagename,
  config.developer,
  config.description,
  path)

  Import_dialog = MaterialAlertDialog(this)
  .setTitle(res.string.import_extension)
  .setMessage(str)
  .setPositiveButton(res.string.install,function()

    local vpath = PathUtil.plug_dir .. "/" .. packagename

    if File(vpath).exists()

      Import_dialog.dismiss()

      MyToast(res.string.import_plug_ok_no)

     else

      Import_dialog.dismiss()

      local Awaiting = ProgressMaterialAlertDialog(this).show()

      if ZipUtil.unzip(path, vpath .. "/")

        try

        refresh()

      end

      MyToast(res.string.install_ok)

     else

      MyToast(res.string.install_no)

    end

    Awaiting.dismiss()

  end

end)
.setNegativeButton(res.string.no)
.show()

end

end

end

local init = function()

  FileList = {}

  Anim = AnimatorSet()

  local X = ObjectAnimator.ofFloat(mRecycler, "translationX", {50, 0})
  local A = ObjectAnimator.ofFloat(mRecycler, "alpha", {0, 1})

  Anim.play(A).with(X)

  Anim.setDuration(400)
  .setInterpolator(DecelerateInterpolator)

  newInstance("me.zhanghai.android.fastscroll.FastScrollerBuilder", mRecycler)
  .useMd2Style()
  .setPadding(0,dp2px(8),dp2px(2),dp2px(8))
  .build()

  c_adapter = PopupRecyclerAdapter(this, PopupRecyclerAdapter.PopupCreator({

    getItemCount = function()

      return #FileList

    end,

    getItemViewType = function()

      return 0

    end,

    getPopupText = function(view, position)

      return utf8.sub(FileList[position+1].file_name,1,1)

    end,

    onViewRecycled = function(holder)

      GlideUtil.clear(holder.Tag.icon)

    end,

    onCreateViewHolder = function(parent,viewType)

      local views = {}
      local holder = LuaCustRecyclerHolder(loadlayout(res.layout.file_item, views))
      holder.Tag = views
      return holder

    end,

    onBindViewHolder = function(holder,position)

      local view = holder.Tag
      local v = FileList[position+1]

      view.name.setText(v.file_name)

      GlideUtil.setImage(res.drawable[v.img], view.icon)

      view.icon.setColorFilter(v.color)

      view.contents.onClick = function()

        if not File(v.path).canRead()

          MyToast(res.string.noreadpms)

          return

        end

        if File(v.path).isDirectory()

          updata(v.path)

         else

          dialog.dismiss()

          _M.Import(v.path)

        end

      end

    end
  }))

  mRecycler.setAdapter(c_adapter).setLayoutManager(LinearLayoutManager())

  return _M

end

local getList = function(path)

  local jpairs = require "jpairs"

  local table_sort = table.sort

  local DirList = {}

  local _FileList = {}

  local fileArray = File(path).list()

  for _, v jpairs(fileArray)

    local full_path = path .. "/" .. v


    if File(full_path).isDirectory()

      local k = #DirList + 1
      DirList[k] = {}
      DirList[k].path = full_path
      DirList[k].name = v
      DirList[k].isDirectory = true

     elseif File(full_path).isFile()

      local ext = string.match(full_path, "%.([^%.]+)$")

      if ext == "alp" or ext == "zip"

        local k = #_FileList + 1
        _FileList[k] = {}
        _FileList[k].path = full_path
        _FileList[k].name = v
        _FileList[k].isDirectory = false

      end

    end

  end

  local sortFunc = function(a, b)

    return a.name < b.name

  end

  table_sort(DirList, sortFunc)

  table_sort(_FileList, sortFunc)

  for _, v in ipairs(_FileList)

    DirList[#DirList + 1] = v

  end

  local isRoot

  if v_path ~= PathUtil.storage_dir

    FileList = {{isDirectory=true,file_name="...",path=File(v_path).getParent(),img="ic_folder_upload_outline",color=0xFF666666}}

   else

    isRoot = true
    FileList = {}

  end

  for k, v in ipairs(DirList)

    if not isRoot

      k = k + 1

     else

      k = k

    end

    FileList[k] = {}

    local fileinfo = FileList[k]

    fileinfo.path = v.path

    fileinfo.file_name = v.name

    fileinfo.isDirectory = v.isDirectory

    if v.isDirectory

      fileinfo.img = "ic_folder_outline"

      fileinfo.color = 0xFFFF972E

     else

      fileinfo.img = "ic_zip_box_outline"

      fileinfo.color = 0xFF1A6EFC

    end

  end

end

local updateCallback = function()

  c_adapter.notifyDataSetChanged()

  Anim.start()

end

updata = function(path)

  if executor.getActiveCount() < executor.getMaximumPoolSize()

    executor.execute(function()

      v_path = path

      getList(v_path)

      handler.post(updateCallback)

    end)

  end

  return _M

end

_M.show = function(i)

  index = i

  v_path = PathUtil.storage_dir

  dialog = BottomSheetDialog.showDialog(res.view.choose_layout)

  mRecycler.post(function()

    init()

    updata(v_path)

  end)

end

return _M