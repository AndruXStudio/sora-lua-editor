local _M = {}

_M.get = function(table, key)
  local val
  pcall(function() val = table[key] end)
  return val
end

return _M