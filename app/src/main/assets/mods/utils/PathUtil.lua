local _M = {}
local Environment = bindClass "android.os.Environment"

_M.storage_dir = tostring(Environment.getExternalStorageDirectory())
_M.media = tostring(luajava.astable(activity.getExternalMediaDirs())[1].getPath())
_M.media_backup = _M.media .. "/backups"
_M.my_dir = _M.storage_dir .. "/LuaAppX"
_M.plug_dir = _M.my_dir .. "/plugins"
_M.project_dir = _M.my_dir .. "/project"
_M.backup_dir = _M.my_dir .. "/backup"
_M.download_dir = _M.my_dir .. "/download"
_M.bin_dir = _M.my_dir .. "/bin"
_M.crash_dir = _M.my_dir .. "/crash"
_M.lualibs_dir = _M.my_dir .. "/lualibs"
_M.solibs_dir = _M.my_dir .. "/solibs"
_M.cache_dir = _M.media .. "/cache"
_M.this_dir = ""
_M.this_file = ""

return _M