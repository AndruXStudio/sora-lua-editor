local exists = io.isdir
local const = table.const
local luadir = activity.luaDir .. "/"
local drawableDir = luadir .. "res/drawable/"
local fontDir = luadir .. "res/font/"
local Layout = require "mods.utils.LayoutUtil"
local loadlayout = require "loadlayout"
local Drawable = luajava.bindClass "android.graphics.drawable.Drawable"
local Locale = luajava.bindClass "java.util.Locale"
local LuaBitmap = luajava.bindClass "com.androlua.LuaBitmap"
local LuaBitmapDrawable = luajava.bindClass "com.androlua.LuaBitmapDrawable"
local Typeface = luajava.bindClass "android.graphics.Typeface"
local Layout = require "mods.utils.LayoutUtil"

local function Meta(func)
  return setmetatable({},{__index=func})
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
    local path = drawableDir .. key
    if exists(path .. ".png") ~= nil then
      return Drawable.createFromPath(path .. ".png")
     elseif exists(path .. ".jpg") ~= nil then
      return Drawable.createFromPath(path .. ".jpg")
     elseif exists(path .. ".gif") ~= nil then
      return Drawable.createFromPath(path .. ".gif")
     elseif exists(path .. ".lua") ~= nil then
      return loadLuaFile(path .. ".lua")
    end
    return nil
  end),
  bitmap = Meta(function(_, key)
    local path = drawableDir .. key
    if exists(path .. ".png") ~= nil then
      return LuaBitmap.getBitmap(activity, path .. ".png")
     elseif exists(path .. ".jpg") ~= nil then
      return LuaBitmap.getBitmap(activity, path .. ".jpg")
     elseif exists(path .. ".gif") ~= nil then
      return LuaBitmap.getBitmap(activity, path .. ".gif")
     elseif exists(path .. ".lua") ~= nil then
      return loadLuaFile(path .. ".lua")
    end
    return nil
  end),
  layout = Meta(function(_, key)
    return require("res.layout." .. key)
  end),
  view = Meta(function(_, key)
    return Layout.inflate("res.layout." .. key, res.env)
  end),
  menu = Meta(function(_, key)
    return require("res.menu." .. key)
  end),
  font = Meta(function(_, key)
    local path = fontDir .. key
    if exists(path .. ".ttf") ~= nil then
      return Typeface.createFromFile(path .. ".ttf")
     elseif exists(path .. ".otf") ~= nil then
      return Typeface.createFromFile(path .. ".otf")
    end
    return nil
  end)
}

local orients = const{
  [1] = "res/dimen/port.lua",
  [2] = "res/dimen/land.lua"
}

res.string = {}

local p = luadir .. "res/string/init.lua"

local defTable = {}
loadLuaFile(p,defTable)
for k, v in pairs(defTable) do
  res.string[k] = v
end

p = luadir .. "res/string/" .. res.language .. ".lua"
-- 如果当前语言文件不存在
if exists(p) == nil then
  -- 从default.lua中读取默认语言
  res.defaultLanguage = loadLuaFile(luadir .. "res/string/default.lua")
  p = luadir .. "res/string/" .. res.defaultLanguage .. ".lua"
end

local langTable = {}
loadLuaFile(p,langTable)
for k, v in pairs(langTable) do
  res.string[k] = v
end
res.string = const(res.string)


res.dimen = {}

local defTable = {}
loadLuaFile(luadir .. "res/dimen/init.lua",defTable)
for k, v in pairs(defTable) do
  res.dimen[k] = v
end

local dimTable = {}
loadLuaFile(luadir .. orients[res.orientation],dimTable)
for k, v in pairs(dimTable) do
  res.dimen[k] = v
end

res.dimen = const(res.dimen)


return res