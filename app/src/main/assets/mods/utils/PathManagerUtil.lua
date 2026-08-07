local _M = {}

_M.update_this_file = function(path)
  PathUtil.this_file = path
end

_M.update_this_dir = function(path)

  PathUtil.this_dir = path
  
end

return _M