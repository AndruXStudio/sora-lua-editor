local File = luajava.bindClass "java.io.File"

if File(activity.getLuaDir() .. "/config.json").isFile()

  chunk, debugger_info = pcall(dofile, activity.getLuaDir() .. "/config.json")

 else

  debugger_info = {}
  chunk, e = pcall(loadfile, activity.getLuaDir() .. "/init.lua", "bt", debugger_info)

end

if !chunk
  
  error(chunk)
  
  return
end

if ! debugger_info.debugmode
  
  return
end

local debuggermode = debugger_info.debuggermode

if debuggermode == 1 or debuggermode == nil

  require "debugger_mode1"
  
 elseif debuggermode == 2
 
  local debugger = require "debugger_mode2"

  debugger(this)
  .showFloatWindow()
  
 elseif debuggermode == 3
 
 else
 
  require "debugger_mode1"
end