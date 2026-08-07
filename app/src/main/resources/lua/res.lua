local bindClass = luajava.bindClass
local exists = io.isdir
local const = table.const
local luadir = activity.luaDir .. "/"
local drawableDir = luadir .. "res/drawable/"
local fontDir = luadir .. "res/font/"
local Drawable = bindClass("android.graphics.drawable.Drawable")
local Locale = bindClass("java.util.Locale")
local LuaBitmap = bindClass("com.androlua.LuaBitmap")
local LuaBitmapDrawable = bindClass("com.androlua.LuaBitmapDrawable")
local Typeface = bindClass("android.graphics.Typeface")

local function Meta(func)
  return setmetatable({}, { __index = func })
end

local function loadFile(path)
  local file = io.open(path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    return content
  end
  return nil
end

local function loadLuaFile(path, env)
  local content = loadFile(path)
  if content then
    local chunk, err = load(content, "@" .. path, "bt", env or _G)
    if chunk then
      return chunk()
     else
      error(err)
    end
  end
  return nil
end

local res = {
  env = _G,
  language = Locale.default.language,
  orientation = activity.resources.configuration.orientation,
  drawable = Meta(function(_, key)
    local formats = { "png", "jpg", "gif" }
    for _, format in ipairs(formats) do
      local path = drawableDir .. key .. "." .. format
      if exists(path) ~= nil then
        return Drawable.createFromPath(path)
      end
    end
    local luaPath = drawableDir .. key .. ".lua"
    if exists(luaPath) ~= nil then
      return loadLuaFile(luaPath)
    end
    return nil
  end),
  bitmap = Meta(function(_, key)
    local formats = { "png", "jpg", "gif" }
    for _, format in ipairs(formats) do
      local path = drawableDir .. key .. "." .. format
      if exists(path) ~= nil then
        return LuaBitmap.getBitmap(activity, path)
      end
    end
    local luaPath = drawableDir .. key .. ".lua"
    if exists(luaPath) ~= nil then
      return loadLuaFile(luaPath)
    end
    return nil
  end),
  layout = Meta(function(_, key)
    return "res.layout." .. key
  end),
  font = Meta(function(_, key)
    local formats = { "ttf", "otf" }
    for _, format in ipairs(formats) do
      local path = fontDir .. key .. "." .. format
      if exists(path) ~= nil then
        return Typeface.createFromFile(path)
      end
    end
    return nil
  end),
  string = {},
  dimen = {},
}

local function loadTableFromLuaFile(filePath, destTable)
  local content = loadFile(filePath)
  if content then
    local chunk, err = load(content, "@" .. filePath, "bt", destTable)
    if chunk then
      chunk()
     else
      error(err)
    end
  end
end

local function mergeTable(sourceTable, destTable)
  for k, v in pairs(sourceTable) do
    destTable[k] = v
  end
end

loadTableFromLuaFile(luadir .. "res/string/init.lua", res.string)

local langFilePath = luadir .. "res/string/" .. res.language .. ".lua"
if exists(langFilePath) == nil then
  res.defaultLanguage = loadLuaFile(luadir .. "res/string/default.lua")
  langFilePath = luadir .. "res/string/" .. res.defaultLanguage .. ".lua"
end
loadTableFromLuaFile(langFilePath, res.string)

loadTableFromLuaFile(luadir .. "res/dimen/init.lua", res.dimen)

res.string = const(res.string)
res.dimen = const(res.dimen)

return res