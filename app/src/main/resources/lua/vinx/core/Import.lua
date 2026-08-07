local _M = {}

local apply = luajava.bindClass
local LuaAsyncTask = apply("com.androlua.LuaAsyncTask")
local LuaThread = apply("com.androlua.LuaThread")
local LuaTimer = apply("com.androlua.LuaTimer")
local Object = apply("java.lang.Object")
local Math = apply("java.lang.Math")

local ACTION_TAGS = {
  of = true,
  as = true,
  lazy = true,
}

local isGlobalImportEnabled = true
local isPackageDeclarationEnabled = true
local isWildcardImportEnabled = true

local function checkConfig(value, defaultValue)
  return value == nil and defaultValue or value
end

local function importModule(name)
  local isOk, result = pcall(require, name)
  if isOk then
    package.loaded[name] = nil
    return isOk, result
   else
    return nil, result
  end
end

local function importInternalClass(name)
  local isOk, result = pcall(luajava.bindClass, name)
  if isOk then
    return result
  end
end

local loaders = luajava.astable(activity.classLoaders)

local function importDexClass(name)
  for _, loader in ipairs(loaders) do
    local isOk, result = pcall(loader.loadClass, name)
    if isOk then
      return result
    end
  end
end

local loaded = {}
local globalPackages = {}

local function importInternal(name, ignoreError)
  local result

  if loaded[name] then
    result = loaded[name]
   elseif isWildcardImportEnabled and name:find("%.%*$") then
    table.insert(globalPackages, name:sub(1, -2))
    return nil
   else
    local isOk, moduleResult = importModule(name)
    result = moduleResult

    if not isOk then
      result = importInternalClass(name) or importDexClass(name)

      if not result then
        if moduleResult:match("error loading") then
          error(moduleResult)
         else
          if not ignoreError then
            error(tostring(moduleResult))
          end
        end
       else
        loaded[name] = result
      end
    end
  end

  return result
end

_M.import = function(statement, ignoreError)
  local name
  local simpleName
  for v in (statement.." "):gmatch("(.-)[ ,:]") do
    if not ACTION_TAGS[v] then
      if not name then
        name = v
        simpleName = v:match("([^%.$]+)$")
      end
    end
  end
  local result = importInternal(name, ignoreError)
  _G[simpleName] = result
  return result
end

_M.imports = function(statements)
  for s in statements:gmatch("[^\n]+") do
    local s = s:match("^%s*(.-)%s*$")
    if s ~= "" and not s:find("^%-%-") then
      _M.import(s)
    end
  end
end

_M.print = function(...)
  local buf = {}
  for n = 1, select("#", ...) do
    buf[#buf+1] = tostring(select(n, ...))
  end
  local msg = table.concat(buf, "\t\t")
  activity.sendMsg(msg)
end

_M.thread = function(src, ...)
  if type(src) == "string" then
    src = checkPath(src)
  end
  local luaThread
  if select("#", ...) > 0 then
    luaThread = LuaThread(activity or service, src, true, Object { ... })
   else
    luaThread = LuaThread(activity or service, src, true)
  end
  luaThread.start()
  return luaThread
end

_M.task = function(src, ...)
  local args = { ... }
  local callback = args[select("#", ...)]
  args[select("#", ...)] = nil
  local luaAsyncTask = LuaAsyncTask(activity or service, src, callback)
  luaAsyncTask.executeOnExecutor(LuaAsyncTask.THREAD_POOL_EXECUTOR, args)
  return luaAsyncTask
end

_M.timer = function(f, d, p, ...)
  local luaTimer = LuaTimer(activity or service, f, Object { ... })
  if p == 0 then
    luaTimer.start(d)
   else
    luaTimer.start(d, p)
  end
  return luaTimer
end

_M.dp2px = function(dpValue)
  local scale = activity.getResources().getDisplayMetrics().density
  return Math.round(dpValue * scale)
end

_M.px2dp = function(pxValue)
  local scale = activity.getResources().getDisplayMetrics().density
  return Math.round(pxValue / scale)
end

_M.px2sp = function(pxValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return Math.round(pxValue / scale)
end

_M.sp2px = function(spValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return Math.round(spValue * scale)
end

_M.onKeyDownX = function(callback)
  if apply("android.os.Build").VERSION.SDK_INT >= 33 then
    local OnBackPressedCallback = apply("androidx.activity.OnBackPressedCallback")
    luacontext.onBackPressedDispatcher.addCallback(luacontext,luajava.override(OnBackPressedCallback, {
      handleOnBackPressed = function()
        callback()
      end
    }, true))
   else
    function onKeyDown(KeyCode, event)
      callback(KeyCode, event)
    end
  end
end

_M.dump = function(o)
  local t, _t, space, deep = {}, {}, string.rep(' ', 2), 0

  local function _ToString(o, _k)
    local o_type, v_type = type(o)

    if o_type == 'number' then
      t[#t + 1] = o
     elseif o_type == 'string' then
      t[#t + 1] = string.format('%q', o)
     elseif o_type == 'table' then
      local mt = getmetatable(o)
      if mt and mt.__tostring then
        t[#t + 1] = tostring(o)
       else
        deep = deep + 2
        t[#t + 1] = '{'

        for k, v in pairs(o) do
          if v ~= _G and v ~= package.loaded then
            local k_str = type(k) == "number" and string.format('[%s]', k) or string.format('[\"%s\"]', k)

            table.insert(t, string.format('\n%s%s = ', string.rep(space, deep - 1), k_str))

            if v == nil then
              table.insert(t, 'nil')
             elseif type(v) == 'table' then
              if _t[tostring(v)] == nil then
                _t[tostring(v)] = _k .. k_str
                _ToString(v, _t[tostring(v)])
               else
                table.insert(t, tostring(_t[tostring(v)]))
              end
             else
              _ToString(v, _k)
            end

            --table.insert(t, ';')
          end
        end

        table.insert(t, string.format('\n%s}', string.rep(space, deep - 1)))
        deep = deep - 2
      end
     else
      t[#t + 1] = tostring(o)
    end

    t[#t + 1] = ';'
  end

  _ToString(o, '')
  return table.concat(t)
end

if isGlobalImportEnabled then
  _G.import = _M.import
  _G.imports = _M.imports
  _G.print = _M.print
  _G.thread = _M.thread
  _G.task = _M.task
  _G.timer = _M.timer
  _G.dp2px = _M.dp2px
  _G.px2dp = _M.px2dp
  _G.px2sp = _M.px2sp
  _G.sp2px = _M.sp2px
  _G.dump = _M.dump
  _G.onKeyDownX = _M.onKeyDownX
  _G.R = apply("com.load.LuaAppX.R")
  _G.android = { R = apply("android.R") }
  _G.L = activity.getLuaState()
  _M.import("loadlayout")
  _M.import("loadbitmap")
  _M.import("loadmenu")
  _M.import("debugger")
  _M.import("java.lang.*")
  _M.import("java.util.*")
  _M.import("java.io.*")
  _M.import("com.androlua.*")
end

if isWildcardImportEnabled then
  setmetatable(_G, {
    __index = function(self, className)
      local result
      for _, packageName in ipairs(globalPackages) do
        result = importInternalClass(packageName..className)
        if result then break end
      end
      if not result then
        for _, packageName in ipairs(globalPackages) do
          result = importDexClass(packageName..className)
          if result then break end
        end
      end
      if result then _G[className] = result end
      return result
    end
  })
end

return setmetatable(_M, {
  __newindex = function() error("IllegalOperationException") end,
  __metatable = function() error("IllegalOperationException") end,
  __tostring = function() return "class vinx.core.importX" end,
  __type = function() return "userdata" end,
})