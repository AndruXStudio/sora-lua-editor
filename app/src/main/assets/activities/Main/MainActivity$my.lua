local _M = {}
local OkHttpUtil = require "mods.utils.OkHttpUtil"
local GlideUtil = require "mods.utils.GlideUtil"

_M.onCreate = function()

  login.onClick = function()

    if not this.getSharedData("username")

      ActivityUtil.new("Login")

    end

  end

  Get_Infor = function()

    OkHttpUtil.post(false, "http://luaappx.top/api/users/getinfor.php",{
      ["username"] = this.getSharedData("username"),
      ["token"] = this.getSharedData("token"),
      },function(code,body)

      if body.status == 1

        logo.setColorFilter(0)
        logo2.setAlpha(1)

        GlideUtil.setImage(body.headimg, logo)

        name.setText(body.nickname)

        sign.setText(body.signature)
        
        pull_my.setRefreshing(false)

      end

    end)

  end

  Get_Infor()

  pull_my.setColorSchemeColors({Colors.colorPrimary})
  pull_my.onRefresh=function()

      Get_Infor()

    end

end

return _M