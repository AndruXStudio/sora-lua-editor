local _M = {}
local ProgressMaterialAlertDialog = require "mods.dialog.ProgressMaterialAlertDialog"
local cjson = require "cjson"
local OkHttpClient = bindClass "okhttp3.OkHttpClient"
local Request = bindClass "okhttp3.Request"
local FormBody = bindClass "okhttp3.FormBody"
local Callback = bindClass "okhttp3.Callback"
local Runnable = bindClass "java.lang.Runnable"

local function okHttp(url,data,callback)
  
  if not mOkHttpClient
    mOkHttpClient = OkHttpClient()
    mOkHttpClient.dispatcher().setMaxRequests(5)
    mOkHttpClient.dispatcher().setMaxRequestsPerHost(2)
  end

  local req = Request.Builder()
  req.url(url)
  
  if data
    
    local arr=FormBody.Builder()
    
    for k,v pairs(data)
      arr.add(k,v)
    end
  
    local requestBody=arr.build()
    req.post(requestBody)
    
  end

  local request=req.build()
  local callz = mOkHttpClient.newCall(request)
  
  callz.enqueue(Callback{
    onFailure=function(call,e)
      
      activity.runOnUiThread(Runnable{
        run = function()
          
          if dialog_code == true
            
            dialog_okhttp.dismiss()
            
          end
        
          return
          -- callback(0,{"code":0,"msg":"Error Message"})
          
        end
      })
    
    end,
  
    onResponse = function(call,response)
      
      local code = response.code()
      local content = tostring(response.body().string())
      
      activity.runOnUiThread(Runnable{
        run = function()
          
          if dialog_code == true
            
            dialog_okhttp.dismiss()
            
          end
        
          callback(code,(function()
            try
              return cjson.decode(content)
              catch
              return content
            end
          end)())
        
        end
      })
    end
  })

end

_M.cjson_decode = cjson.decode

function _M.post(code,url,data,callback)
  
  dialog_code = code
  
  if code == true
    
    dialog_okhttp = ProgressMaterialAlertDialog(this).show()
    
  end

  okHttp(url,data,callback)
  
end

function _M.get(code,url,callback)
  
  dialog_code = code
  
  if code == true
    
    dialog_okhttp = ProgressMaterialAlertDialog(this).show()
  
  end

  okHttp(url,nil,callback)
  
end

return _M