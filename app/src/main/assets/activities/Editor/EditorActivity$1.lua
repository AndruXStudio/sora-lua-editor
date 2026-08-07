local _M = {}
local MimeTypeMap = bindClass "android.webkit.MimeTypeMap"
local Intent = bindClass "android.content.Intent"
local LuaUtil = bindClass "com.androlua.LuaUtil"
local BottomSheetDialog = require "mods.dialog.BottomSheetDialog"
local DialogUtil = require "mods.utils.DialogUtil"
local ChangeUtil = require "mods.utils.ChangeUtil"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local LuaFileUtil = require "mods.utils.LuaFileUtil"
local TabUtil = require "mods.utils.TabUtil"

local GetMimeType = function(path)

  local MimeType = MimeTypeMap.getSingleton()
  local mime = MimeType.getMimeTypeFromExtension(string.match(path, ".+%.(%w+)$"))

  if not mime

    return string.match(path, ".+%.(%w+)$") or "UNKNOWN"

   else

    return mime

  end

end

local function GetFileSize(path)

  local File = luajava.bindClass "java.io.File"
  local Formatter = luajava.bindClass "android.text.format.Formatter"
  local size = File(tostring(path)).length()

  Sizes=Formatter.formatFileSize(this, size)

  return Sizes

end

local function getFolderSizes(folderPath,t)

  local getFolderSizes = t[1]
  local luajava = t[2]
  local File = luajava.bindClass "java.io.File"
  local size = 0
  local fileList = luajava.astable(File(folderPath).listFiles())

  if fileList == nil
    return 0
  end

  for count = 1, #fileList

    if fileList[count].isDirectory()
      --        size = size + getFolderSizes(tostring(fileList[count]),false,t)
     else
      size = size + fileList[count].length()
    end

  end
  local GB = 1024 * 1024 * 1024
  local MB = 1024 * 1024
  local KB = 1024
  local countResult

  if size >= GB

    countResult = string.format("%.2f", size / GB) .. " GB"

   elseif size >= MB

    countResult = string.format("%.2f", size / MB) .. " MB"

   elseif size >= KB

    countResult = string.format("%.2f", size / KB) .. " KB"

   else

    countResult = size .. " B"

  end

  return countResult

end

local function GetFilelastTime(path)

  local f = File(path)
  local cal = Calendar.getInstance()
  local time = f.lastModified()

  cal.setTimeInMillis(time)

  return cal.getTime().toLocaleString()

end

local newDir = function(path)

  File(path).mkdirs()
  FileListUtil.updata()

end

_M.deleteFile = function(path)

  LuaUtil.rmDir(File(path))
  FileListUtil.delete(path)
  FileListUtil.updata()

end

_M.fileMenu = function(path, name)

  local file_dialog = BottomSheetDialog.showDialog(res.view.file_dialog)

  filename.setText(name)

  time.setText(GetFilelastTime(path))

  prefSize.setSubTitle(GetFileSize(path) .. " (" .. File(path).length() .. ")")

  perfPath.setSubTitle(path)

  prefType.setSubTitle(GetMimeType(path))

  perfMD5.setSubTitle("ing...")

  this.newTask(function(path)

    local File = luajava.bindClass "java.io.File"
    local StringBuffer = luajava.bindClass "java.lang.StringBuffer"
    local FileInputStream = luajava.bindClass "java.io.FileInputStream"
    local MessageDigest = luajava.bindClass "java.security.MessageDigest"
    local Array = luajava.bindClass "java.lang.reflect.Array"
    local Byte = luajava.bindClass "java.lang.Byte"
    local Integer = luajava.bindClass "java.lang.Integer"

    local stringBuffer = StringBuffer()
    local file = FileInputStream(File(path))
    local md5 = MessageDigest.getInstance("md5")
    local byteArray = Array.newInstance(Byte.TYPE, 1024 * 1024)

    while (file.read(byteArray) ~= -1)
      md5.update(byteArray)
    end

    file.close()

    local bytes = md5.digest()

    for k,n ipairs(luajava.astable(bytes))

      temp = Integer.toHexString(n&255)
      if #temp == 1 stringBuffer.append("0") end
      stringBuffer.append(temp)

    end

    return stringBuffer

    end,function(stringBuffer)

    perfMD5.setSubTitle(stringBuffer)

  end).execute({path})

  rename.onClick = function()

    file_dialog.dismiss()

    local Redialog = MaterialAlertDialog(this)
    .setTitle(res.string.rename)
    .setView(res.view.dialog_fileinput)
    .setPositiveButton(res.string.ok)
    .setNegativeButton(res.string.no)
    .create()

    DialogUtil.onShow(Redialog,function()

      local new_path = PathUtil.this_dir .. "/" .. tostring(file_name.getText())

      if File(new_path).exists()
        textInput_name.setError(TypefaceString(res.string.exists_file))
        return
      end

      LuaFileUtil.rename(path, new_path)

      FileListUtil.updata()
      TabUtil.remove(path)
      Redialog.dismiss()

    end)

    Redialog.show()
    ChangeUtil.EditTextChanged({file_name}, {textInput_name})
    file_name.setText(name)

    local _,splitEnd = utf8.find(name, ".+%.")

    if splitEnd
      splitEnd = splitEnd - 1
    end

    file_name.post({
      run = function()

        file_name.requestFocus()
        file_name.setSelection(0, splitEnd or utf8.len(name))

      end
    })

  end

  createfile.onClick = function()

    file_dialog.dismiss()

    Newdialog = MaterialAlertDialog(this)
    .setTitle(res.string.c_f)
    .setView(res.view.dialog_fileinput)
    .setPositiveButton(res.string.ok)
    .setNegativeButton(res.string.no)
    .create()

    DialogUtil.onShow(Newdialog,function()
      local new_path = PathUtil.this_dir .. "/" .. tostring(file_name.getText())

      if File(new_path).exists()
        textInput_name.setError(TypefaceString(res.string.exists_file))
        return
      end

      LuaFileUtil.create(new_path, "")
      FileListUtil.updata()
      Newdialog.dismiss()

    end)

    Newdialog.show()
    ChangeUtil.EditTextChanged({file_name}, {textInput_name})

  end

  createdir.onClick = function()

    file_dialog.dismiss()

    Newdialog = MaterialAlertDialog(this)
    .setTitle(res.string.c_f2)
    .setView(res.view.dialog_fileinput)
    .setPositiveButton(res.string.ok)
    .setNegativeButton(res.string.no)
    .create()

    DialogUtil.onShow(Newdialog,function()

      local new_path = PathUtil.this_dir .. "/" .. tostring(file_name.getText())

      if File(new_path).exists()
        textInput_name.setError(TypefaceString(res.string.exists_file))
        return
      end

      newDir(new_path)
      Newdialog.dismiss()

    end)

    Newdialog.show()
    ChangeUtil.EditTextChanged({file_name},{textInput_name})

  end

  delete.onClick = function()

    file_dialog.dismiss()

    if mTab.getTabCount() == 1 and path == PathUtil.this_file

      MyToast(res.string.must_one)
      return true

    end

    MaterialAlertDialog(this)
    .setTitle(res.string.delete)
    .setMessage((res.string.ok_delete_no):format(name))
    .setPositiveButton(res.string.ok, function()

      TabUtil.remove(path)
      _M.deleteFile(path)

    end)
    .setNegativeButton(res.string.no, nil)
    .show()

  end

end

_M.dirMenu = function(path, name)

  local folder_dialog = BottomSheetDialog.showDialog(res.view.folder_dialog)

  foldername.setText(name)

  time.setText(GetFilelastTime(path))

  perfPath.setSubTitle(path)

  task(getFolderSizes,path,{getFolderSizes,luajava},function(size)

    prefSize.setSubTitle(size)

  end)

  rename.onClick = function()

    folder_dialog.dismiss()

    local Redialog = MaterialAlertDialog(this)
    .setTitle(res.string.rename)
    .setView(res.view.dialog_fileinput)
    .setPositiveButton(res.string.ok)
    .setNegativeButton(res.string.no)
    .create()

    DialogUtil.onShow(Redialog,function()
      local new_path = PathUtil.this_dir .. "/" .. tostring(file_name.getText())

      if File(new_path).exists()
        textInput_name.setError(TypefaceString(res.string.exists_file))
        return
      end

      LuaFileUtil.rename(path, new_path)
      FileListUtil.updata()
      TabUtil.checkAll()
      Redialog.dismiss()

    end)

    Redialog.show()
    ChangeUtil.EditTextChanged({file_name}, {textInput_name})

    file_name.setText(name)
    file_name.post({
      run = function()

        file_name.requestFocus()
        file_name.setSelection(0, utf8.len(name))

      end
    })

  end

  createfile.onClick = function()

    folder_dialog.dismiss()

    local Newdialog = MaterialAlertDialog(this)
    .setTitle(res.string.c_f)
    .setView(res.view.dialog_fileinput)
    .setPositiveButton(res.string.ok)
    .setNegativeButton(res.string.no)
    .create()

    DialogUtil.onShow(Newdialog,function()

      local new_path = path .. "/" .. tostring(file_name.getText())

      if File(new_path).exists()
        textInput_name.setError(TypefaceString(res.string.exists_file))
        return
      end

      LuaFileUtil.create(new_path, "")

      MyToast(res.string.create_ok)
      Newdialog.dismiss()

    end)

    Newdialog.show()
    ChangeUtil.EditTextChanged({file_name}, {textInput_name})

  end

  createdir.onClick = function()

    folder_dialog.dismiss()

    local Newdialog = MaterialAlertDialog(this)
    .setTitle(res.string.c_f2)
    .setView(res.view.dialog_fileinput)
    .setPositiveButton(res.string.ok)
    .setNegativeButton(res.string.no)
    .create()

    DialogUtil.onShow(Newdialog,function()

      local new_path = path .. "/" .. tostring(file_name.getText())

      if File(new_path).exists()

        textInput_name.setError(TypefaceString(res.string.exists_file))
        return

      end

      File(new_path).mkdirs()
      MyToast(res.string.create_ok)
      Newdialog.dismiss()

    end)

    Newdialog.show()
    ChangeUtil.EditTextChanged({file_name}, {textInput_name})

  end

  delete.onClick = function()

    folder_dialog.dismiss()

    if mTab.getTabCount() == 1 and (PathUtil.this_file):find(path)

      MyToast(res.string.must_one)
      return true

    end

    MaterialAlertDialog(this)
    .setTitle(res.string.delete)
    .setMessage((res.string.ok_delete_no):format(name))
    .setPositiveButton(res.string.ok, function()

      _M.deleteFile(path)
      TabUtil.checkAll()

    end)

    .setNegativeButton(res.string.no)
    .show()

  end

end

_M.InstallApk = function(filePath)

  local intent = Intent(Intent.ACTION_VIEW)
  intent.addCategory("android.intent.category.DEFAULT")
  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

  local uri = this.getUriForPath(filePath)
  intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
  intent.setDataAndType(uri, "application/vnd.android.package-archive")

  this.startActivity(intent)

end

_M.openFile = function(path, FileName)

  try

    local ExtensionName = FileName:match("%.(.+)")
    local Mime = MimeTypeMap.getSingleton().getMimeTypeFromExtension(ExtensionName)
    local intent = Intent()
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.setAction(Intent.ACTION_VIEW)

    local uri = this.getUriForPath(path)
    if Mime
      intent.setDataAndType(uri, Mime)
     else
      intent.setDataAndType(uri, "text/*")
    end

    this.startActivity(intent)

    catch

    MyToast(res.string.not_supported_file)

  end

end

_M.backup = function(path)

  local e, info = dofile2(path)

  if e

    local alppath = PathUtil.backup_dir .. "/" .. info.label .. "_" .. tostring(info.versionName):gsub("%.", "_") .. "_" .. os.date("%y%m%d%H%M%S") .. ".alp"

    if LuaFileUtil.zip(path, PathUtil.backup_dir)

      LuaFileUtil.rename(PathUtil.backup_dir .. "/" .. File(path).getName() .. ".zip", alppath)

      return res.string.backup_ok .. "：" .. alppath

     else

      return res.string.backup_no

    end

   else

    return res.string.backup_no

  end

end

return _M