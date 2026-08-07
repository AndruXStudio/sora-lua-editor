local _M = {}

_M.sdks = {
  { codename = "Ice Cream Sandwich", version = "4.0.3", api = 15 },
  { codename = "Jelly Bean", version = "4.1", api = 16 },
  { codename = "Jelly Bean", version = "4.2", api = 17 },
  { codename = "Jelly Bean", version = "4.3", api = 18 },
  { codename = "KitKat", version = "4.4", api = 19 },
  { codename = "KitKat Watch", version = "4.4W", api = 20 },
  { codename = "Lollipop", version = "5.0", api = 21 },
  { codename = "Lollipop", version = "5.1", api = 22 },
  { codename = "Marshmallow", version = "6.0", api = 23 },
  { codename = "Naughat", version = "7.0", api = 24 },
  { codename = "Naughat", version = "7.1", api = 25 },
  { codename = "Oreo", version = "8.0", api = 26 },
  { codename = "Oreo", version = "8.1", api = 27 },
  { codename = "Pie", version = "9.0", api = 28 },
  { codename = "Q", version = "10", api = 29 },
  { codename = "R", version = "11", api = 30 },
  { codename = "SnowCone", version = "12", api = 31 },
  { codename = "SnowCone", version = "12L", api = 32 },
  { codename = "Tiramisu", version = "13", api = 33 },
  { codename = "UpsideDownCake", version = "14", api = 34 },
}

_M.getList = function(sdk)

  local data = {}

  for k,v pairs(_M.sdks)
    
    if sdk and sdk == tostring(v.api)
      
      return "SDK " .. v.api .. ": Android " .. v.version .. " (" .. v.codename .. ")"
      
    end

    table.insert(data,"SDK " .. v.api .. ": Android " .. v.version .. " (" .. v.codename .. ")")

  end

  return data

end

_M.getVersion = function(sdk)
  
  local sdk = tostring(sdk)

  for k,v pairs(_M.sdks)

    if sdk == tostring(v.api)

      return { codename = v.codename, version = v.version }

    end

  end

  return { codename = "UNKNOWN", version = "UNKNOWN" }

end

return _M