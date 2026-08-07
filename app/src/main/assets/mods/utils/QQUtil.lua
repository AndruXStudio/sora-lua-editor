--by 一只小柒夏
--qq 2673026892
local Bundle = bindClass "android.os.Bundle"
local Intent = bindClass "android.content.Intent"
local JSONObject = bindClass "org.json.JSONObject"
local ProgressMaterialAlertDialog = require "mods.dialog.ProgressMaterialAlertDialog"
local cjson = require "cjson"

local startLoginActivity = function(packageName, intent, callback)

  local Class_Activity = "com.tencent.open.agent.AgentActivity"
  intent.setClassName(packageName, Class_Activity)
  this.startActivityForResult(intent, 1726)

  onActivityResult = function(requestCode, resultCode, intent)
    local Activity = luajava.bindClass "android.app.Activity"
    if requestCode == 1726 and resultCode == Activity.RESULT_OK
      if not intent.getExtras().getString("key_response")

        MyToast("返回数据为空，请校验互联AppID是否有效")

        return

       elseif intent and type(callback) == "function"


        try

          Awaiting = ProgressMaterialAlertDialog(this).show()

          local appeid = activity.getSharedData("appeid")
          local openid = cjson.decode(intent.getExtras().getString("key_response")).openid
          local access_token = cjson.decode(intent.getExtras().getString("key_response")).access_token
          local userurlformat = string.format("https://graph.qq.com/user/get_user_info?access_token=%s&oauth_consumer_key=%s&openid=%s",access_token,appeid,openid)

          Http.get(userurlformat,function(code,json)

            local json = JSONObject(json).put("openid",openid)
            callback(code, cjson.decode(json.toString()))

          end)

        end

      end
    end
  end

  MyToast(res.string.opening_qq)

end

QQLogin = function(appeid, callback)

  local appeid = tostring(appeid)

  local intent, bundle, bundle2 = Intent(), Bundle(), Bundle()
  bundle.putString("format", "json").putString("client_id", appeid)
  bundle2.putBundle("key_params", bundle).putString("appeid", appeid)
  bundle2.putString("key_request_code", "11101").putString("key_action", "action_login")
  intent.putExtras((bundle2));activity.setSharedData("appeid",appeid)
  startLoginActivity("com.tencent.mobileqq", intent, callback)

end