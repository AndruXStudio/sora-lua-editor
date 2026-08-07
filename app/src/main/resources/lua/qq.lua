--by 一只小柒夏
--qq 2673026892

local Bundle = luajava.bindClass "android.os.Bundle"
local Intent = luajava.bindClass "android.content.Intent"
local JSONObject = luajava.bindClass "org.json.JSONObject"
local cjson = require "cjson"

local function startLoginActivity(packageName, intent, callback)
  local Class_Activity = "com.tencent.open.agent.AgentActivity"
  intent.setClassName(packageName, Class_Activity)
  activity.startActivityForResult(intent, 1726)
  function onActivityResult(requestCode, resultCode, intent)
    local Activity = luajava.bindClass "android.app.Activity"
    if requestCode == 1726 and resultCode == Activity.RESULT_OK then
      if not intent.getExtras().getString("key_response") then
        return
       elseif intent and type(callback) == "function" and xpcall(function()
        local appeid=activity.getSharedData("appeid")
        local openid=cjson.decode(intent.getExtras().getString("key_response")).openid
        local access_token=cjson.decode(intent.getExtras().getString("key_response")).access_token
        local userurlformat = string.format("https://graph.qq.com/user/get_user_info?access_token=%s&oauth_consumer_key=%s&openid=%s",access_token,appeid,openid)
        Http.get(userurlformat,function(code,json)
          local json = JSONObject(json).put("openid",openid);
          callback(code,json.toString())
        end)
      end
      ,function(error)
        print(error)
      end)
    end
   elseif not intent then
    return
  end
end
end

function QQLogin(appeid, callback)
  local appeid = tostring(appeid)
  if not appeid or appeid == "nil" then
    return
  end
  local intent,bundle,bundle2=Intent(),Bundle(),Bundle()
  bundle.putString("format", "json").putString("client_id", appeid)
  bundle2.putBundle("key_params", bundle).putString("appeid", appeid)
  bundle2.putString("key_request_code", "11101").putString("key_action", "action_login")
  intent.putExtras((bundle2));activity.setSharedData("appeid",appeid)
  startLoginActivity("com.tencent.mobileqq", intent, callback)
end