require "environment"
local WindowManager = bindClass "android.view.WindowManager"
local ChangeUtil = require "mods.utils.ChangeUtil"
local OkHttpUtil = require "mods.utils.OkHttpUtil"
local DrawableUtil = require "mods.utils.DrawableUtil"
local QQUtil = require "mods.utils.QQUtil"

this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)

this {
  ContentView = res.view.login_layout,
  SupportActionBar = toolbar
}
.getSupportActionBar()
{
  DisplayHomeAsUpEnabled = true
}

onOptionsItemSelected = function(v)

  if v.getItemId() == android.R.id.home

    finish()

  end

end

onCreateOptionsMenu = function(menu)

  menu.add(TypefaceString(res.string.qq_login))
  .setShowAsAction(2)
  .setIcon(DrawableUtil("ic_qq",Colors.colorOnSurfaceVariant))
  .onMenuItemClick=function()

    QQLogin("102107147",function(code, body)

      if code == 200

        OkHttpUtil.post(false, "http://luaappx.top/api/account/qqlogin.php",{
          ["openid"] = tostring(body.openid)
          },function(code,body)

          Awaiting.dismiss()

          if body.status == 1

            this.setSharedData("username", body.username)
            this.setSharedData("token", body.token)

            this.result { body.message }
            finish()

           else

            MyToast(body.message)

          end

        end)

      end

    end)

  end

end

login.post{
  run = function()

    local height = login.getHeight()

    linearParams = bottom.getLayoutParams()
    linearParams.height = height
    bottom.setLayoutParams(linearParams)

  end
}

forgot.onClick = function(v)

  textInput_qq.setErrorEnabled(false)
  textInput_account.setErrorEnabled(false)
  textInput_password.setErrorEnabled(false)

  textInput_account.Visibility = 0
  textInput_qq.Visibility = 0
  textInput_password.Visibility = 8

  if v.getText() == string.lower(res.string.retrieve_password)

    login.setText(res.string.retrieve)
    v.setText(string.lower(res.string.login_account))
    register.setText(string.lower(res.string.register_account))
    title.setText(res.string.retrieve_password)
    content.setText(res.string.retrieve_tip)

   elseif v.getText() == string.lower(res.string.login_account)

    textInput_account.Visibility = 0
    textInput_qq.Visibility = 8
    textInput_password.Visibility = 0

    v.setText(string.lower(res.string.retrieve_password))
    login.setText(res.string.login)
    title.setText(res.string.login_account)
    content.setText(res.string.login_tip)

  end

end

login.onClick = function(v)

  local qq_text = tostring(qq.getText())
  local account_text = tostring(account.getText())
  local password_text = tostring(password.getText())

  if v.getText() == res.string.login

    if account_text == ""

      textInput_account.setError(TypefaceString(res.string.please_account))

     elseif password_text == ""

      textInput_password.setError(TypefaceString(res.string.please_password))

     else

      OkHttpUtil.post(true, "http://luaappx.top/api/account/login.php",{
        ["username"] = account_text,
        ["password"] = password_text,
        },function(code,body)

        if body.status == 1

          this.setSharedData("username", account_text)
          this.setSharedData("token", body.token)

          this.result { body.message }
          finish()

         else

          MyToast(body.message)

        end

      end)

    end

   elseif v.getText() == res.string.register

    if account_text == ""

      textInput_account.setError(TypefaceString(res.string.please_account))

     elseif password_text == ""

      textInput_password.setError(TypefaceString(res.string.please_password))

     elseif qq_text == ""

      textInput_qq.setError(TypefaceString(res.string.please_qq))

     else

      OkHttpUtil.post(true, "http://luaappx.top/api/account/register.php", {
        ["qq"] = qq_text,
        ["username"] = account_text,
        ["password"] = password_text,
        },function(code,body)

        MyToast(body.message)

      end)

    end

   elseif v.getText() == res.string.retrieve

    if account_text == ""

      textInput_account.setError(TypefaceString(res.string.please_account))

     elseif qq_text == ""

      textInput_qq.setError(TypefaceString(res.string.please_qq))

     else

      OkHttpUtil.post(true, "http://luaappx.top/api/account/forgetpassword.php", {
        ["username"] = account_text,
        ["qq"] = qq_text,
        },function(code,body)

        MyToast(body.message)

      end)

    end

  end

end


register.onClick = function(v)

  forgot.setText(string.lower(res.string.retrieve_password))
  textInput_qq.setErrorEnabled(false)
  textInput_account.setErrorEnabled(false)
  textInput_password.setErrorEnabled(false)

  if v.getText() == string.lower(res.string.register_account)

    textInput_account.Visibility = 0
    textInput_qq.Visibility = 0
    textInput_password.Visibility = 0

    v.setText(string.lower(res.string.login_account))
    login.setText(res.string.register)
    title.setText(res.string.register_account)
    content.setText(res.string.registr_tip)

   elseif v.getText() == string.lower(res.string.login_account)

    textInput_account.Visibility = 0
    textInput_qq.Visibility = 8
    textInput_password.Visibility = 0

    v.setText(string.lower(res.string.register_account))
    login.setText(res.string.login)
    title.setText(res.string.login_account)
    content.setText(res.string.login_tip)

  end

end

ChangeUtil.EditTextChanged({mailbox,qq,account,password},{textInput_mailbox,textInput_qq,textInput_account,textInput_password})