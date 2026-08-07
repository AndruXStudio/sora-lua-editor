local _M = {}
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local PopupRecyclerAdapter = bindClass "github.znzsofficial.adapter.PopupRecyclerAdapter"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local DecelerateInterpolator = newInstance "android.view.animation.DecelerateInterpolator"
local ObjectAnimator = bindClass "android.animation.ObjectAnimator"
local AnimatorSet = bindClass "android.animation.AnimatorSet"
local Runtime = bindClass "java.lang.Runtime"
local Executors = bindClass "java.util.concurrent.Executors"
local HandlerCompat = bindClass "androidx.core.os.HandlerCompat"
local Looper = bindClass "android.os.Looper"
local mainLooper = Looper.getMainLooper()
local handler = HandlerCompat.createAsync(mainLooper)
local executor = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors())
local GlideUtil = require "mods.utils.GlideUtil"
local PathManagerUtil = require "mods.utils.PathManagerUtil"
local EditorUtil = require "mods.utils.EditorUtil"

local suffix_image_map = {
  lua = "ic_file_code_outline",
  luac = "ic_file_code_outline",
  aly = "ic_code_json",
  ttf = "ic_file_ttf_outline",
  otf = "ic_file_ttf_outline",
  jks = "ic_file_key_outline",
  key = "ic_file_key_outline",
  java = "ic_language_java",
  kt = "ic_language_java",
  kts = "ic_language_java",
  py="ic_language_python",
  pyw="ic_language_python",
  pyc="ic_language_python",
  html="ic_language_html5",
  htm="ic_language_html5",
  css="ic_language_css3",
  js="ic_language_javascript",
  ts="ic_language_typescript",
  gradle="ic_language_gradle",
  xml = "ic_xml",
  apk = "ic_file_apk",
  aab = "ic_file_apk",
  class = "ic_language_java",
  jar = "ic_language_java",
  dex = "ic_language_java",
  alp = "ic_zip_box_outline",
  zip = "ic_zip_box_outline",
  bak = "ic_zip_box_outline",
  yml = "ic_code_json",
  yaml = "ic_code_json",
  json = "ic_code_json",
  txt = "ic_file_txt_outline",
  flac = "ic_file_music_outline",
  mp3 = "ic_file_music_outline",
  wav = "ic_file_music_outline",
  mp4 = "ic_file_video_outline",
  m3u8 = "ic_file_video_outline",
  avi = "ic_file_video_outline",
  png = "ic_file_image_outline",
  jpg = "ic_file_image_outline",
  jpeg = "ic_file_image_outline",
  gif ="ic_file_image_outline",
}

local suffix_image = setmetatable({}, {
  __index = function(t, key)
    return suffix_image_map[key] or "ic_insert_drive_file"
  end
})

local suffix_color_map = {
  lua = 0xFF1734FF,
  luac = 0xFF1734FF,
  aly = 0xFFE482A7,
  ttf = 0xFF1734FF,
  otf = 0xFF1734FF,
  jks = 0xFF1734FF,
  key = 0xFF1734FF,
  java = 0xFFF5820E,
  kt = 0xFFF5820E,
  kts = 0xFFF5820E,
  py = 0xFF757575,
  pyc = 0xFF757575,
  pyw = 0xFF757575,
  html = 0xFFFF5722,
  htm = 0xFFFF5722,
  css = 0xFF1565C0,
  js = 0xFFFBC02d,
  ts = 0xFF1565C0,
  gradle = 0xFF0097A7,
  xml = 0xFF07BCF8,
  apk = 0xFF00B900,
  aab = 0xFF00B900,
  class = 0xFFF5820E,
  jar = 0xFFF5820E,
  dex = 0xFFF5820E,
  alp = 0xFF1A6EFC,
  zip = 0xFF1A6EFC,
  bak = 0xFF1A6EFC,
  yml = 0xFFE482A7,
  yaml = 0xFFE482A7,
  json = 0xFFE482A7,
  txt = 0xFFFFBE00,
  flac = 0xFFFF6D17,
  mp3 = 0xFFFF6D17,
  wav = 0xFFFF6D17,
  mp4 = 0xFF6330FD,
  m3u8 = 0xFF6330FD,
  avi = 0xFF6330FD,
  png = 0xFF6E16FE,
  jpg = 0xFF6E16FE,
  jpeg = 0xFF6E16FE,
  gif = 0xFF6E16FE,
}

local suffix_color = setmetatable({}, {
  __index = function(t, key)
    return suffix_color_map[key] or 0xFF666666
  end
})

local function ends(s,End)

  return End == "" or string.sub(s,-string.len(End)) == End

end

_M.init = function()

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

  FileList = {}

  adapter = PopupRecyclerAdapter(this, PopupRecyclerAdapter.PopupCreator({

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

      local path = tostring(v.path)

      view.name.setText(v.file_name)

      if v.isDirectory

        if v.file_name == "mods" or v.file_name == "libs"

          GlideUtil.setImage(res.drawable["ic_folder_table_outline"], view.icon)
          view.icon.setColorFilter(0xFF137CE6)

         elseif v.img == "folder_up"

          GlideUtil.setImage(res.drawable["ic_folder_upload_outline"], view.icon)
          view.icon.setColorFilter(v.color)

         else

          GlideUtil.setImage(res.drawable["ic_folder_outline"], view.icon)
          view.icon.setColorFilter(0xFFFF972E)

        end

       else

        GlideUtil.setImage(res.drawable[v.img], view.icon)
        view.icon.setColorFilter(v.color)

      end

      view.contents.onClick = function()

        if not File(path).canRead()
          MyToast(res.string.noreadpms)
          return
        end

        if v.isDirectory

          if path == PathUtil.project_dir
            return
          end

          PathManagerUtil.update_this_dir(path)

          filetab.setPath(PathUtil.this_dir)

          _M.updata()

         elseif ends(path,".lua")
          or ends(path,".aly")
          or ends(path,".txt")
          or ends(path,".json")
          or ends(path,".html")
          or ends(path,".xml")

          EditorUtil.save()

          EditorUtil.fromRecy = true
          EditorUtil.load(path)


          drawer.closeDrawer(3)

         elseif v.img == "ic_file_image_outline"

          ActivityUtil.new("Photo", { v.path })

         elseif v.img == "ic_file_apk"

          EditorTool.InstallApk(path)

         else

          EditorTool.openFile(path, v.file_name)

        end
      end

      view.contents.setOnLongClickListener(this.onLongClickX(function()

        if v.img == "folder_up"

          return

         elseif not File(path).canRead()

          MyToast(res.string.noreadpms)

         elseif v.isDirectory

          EditorTool.dirMenu(path, v.file_name)

         else

          EditorTool.fileMenu(path, v.file_name)

        end

        return true

      end))


    end,
  }))
  mRecycler.setAdapter(adapter).setLayoutManager(LinearLayoutManager())

  return _M

end

local getList = function()

  local jpairs = require "jpairs"

  local path = PathUtil.this_dir

  local table_sort = table.sort

  local DirList = {}

  local _FileList = {}

  local fileArray = File(path).list()

  for _, v jpairs(fileArray)

    local full_path = path.."/"..v

    if File(full_path).isDirectory()

      local k = #DirList + 1
      DirList[k] = {}
      DirList[k].path = full_path
      DirList[k].name = v
      DirList[k].isDirectory = true

     else

      local k = #_FileList + 1
      _FileList[k] = {}
      _FileList[k].path = full_path
      _FileList[k].name = v
      _FileList[k].isDirectory = false

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

  if PathUtil.this_dir ~= PathUtil.storage_dir

    FileList = {{isDirectory=true,file_name="...",path=File(PathUtil.this_dir).getParent(),img="folder_up",color=0xFF666666}}

   else

    isRoot = true
    FileList = {}

  end

  for k, v in ipairs(DirList)

    local v_path = v.path

    if not isRoot

      k = k + 1

     else

      k = k

    end

    FileList[k] = {}

    local fileinfo = FileList[k]

    fileinfo.path = v_path

    fileinfo.file_name = v.name

    fileinfo.isDirectory = v.isDirectory

    if v.isDirectory

      fileinfo.img = "folder"

     else

      local ext = string.match(v_path, "%.([^%.]+)$")
      
      fileinfo.img = suffix_image[ext]
      fileinfo.color = suffix_color[ext]

    end

  end

end

local updateCallback = function()

  adapter.notifyDataSetChanged()

  Anim.start()

  swipeRefresh.setRefreshing(false)

end

_M.updata = function()

  if executor.getActiveCount() < executor.getMaximumPoolSize()

    executor.execute(function()

      getList()

      handler.post(updateCallback)

    end)

  end

  return _M

end

_M.delete = function(path)

  for k, v in ipairs(FileList)

    if v["path"] == path

      table.remove(FileList, k)

    end

  end

end

return _M