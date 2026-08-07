local _M = {}
local bindClass = luajava.bindClass
local ZipUtil = bindClass "com.androlua.ZipUtil"
local LuaUtil = bindClass "com.androlua.LuaUtil"

_M.create = function(path,content)
  
  local file = File(path)
  
  if not file.exists()
    
    file.createNewFile()
    
    _M.write(path, content)
    
    
  end
  
end

_M.unZip = function(inpath, outpath)

  return ZipUtil.unzip(inpath, outpath)

end

_M.zip = function(inpath, outpath)

  return ZipUtil.zip(inpath, outpath)

end

_M.copyFile = function(inpath, outpath)

  return LuaUtil.copyFile(inpath, outpath)

end

_M.remove = function(path)

  return os.execute([[rm -rf "]]..path..[["]])

end

_M.write = function(path, content)

  try

    io.open(path,"w"):write(content):close()

    return true

    catch

    return false

  end

end

_M.read = function(path)

  return io.open(path):read("*a")

end

_M.checkBackup = function()

  local backup = File(PathUtil.media_backup .. "/" .. os.date("%Y-%m-%d"))

  if not backup.exists()
  
    backup.mkdirs()
    
  end

end

_M.rename = function(old, new)
  
  try
  
    local oldFile = File(old)
    local newFile = File(new)
    
    return oldFile.renameTo(newFile)
    
    catch
    
    return false
    
  end
  
end



return _M