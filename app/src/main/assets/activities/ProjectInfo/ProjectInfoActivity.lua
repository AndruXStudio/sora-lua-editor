require "environment"
local LuaUtil = bindClass "com.androlua.LuaUtil"
local MediaStore = bindClass "android.provider.MediaStore"
local Intent = bindClass "android.content.Intent"
local GlideUtil = require "mods.utils.GlideUtil"
local permission = require "permission"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local ChangeUtil = require "mods.utils.ChangeUtil"

local luaproject = ...

this {
  Title = res.string.project_properties,
  ContentView = res.view.projectinfo_layout,
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

e, info = dofile2(luaproject)

if e

  local icon_path = luaproject .. "/icon.png"

  GlideUtil.setImage(tostring((function if File(icon_path).isFile() return icon_path else return this.getLuaDir("icon.png") end end)()), icon)

  project_name.setText(info.label or "MyLuaApp")

  project_package.setText(info.package or "com.mycompany.myluaapp")

  project_appver.setText(tostring(info.versionName) or "1.0")

  project_appcode.setText(tostring(info.versionCode) or "1099")

  project_sdk.setText(tostring(info.minSdkVersion .. "/" .. info.targetSdkVersion) or "23/29")

  debugmode2.setChecked(info.debugmode or true)

  pcs = {}

  for k,v ipairs(info.user_permission or {})

    table.insert(pcs,v)

  end

  skip = {}

  for k,v ipairs(info.skip_compilation or {})

    table.insert(skip,v)

  end

  debuggermode = info.debuggermode

end

icon2.onClick = function()

  local i = Intent(Intent.ACTION_PICK)
  i.setType("image/*")
  this.startActivityForResult(i, 1)

  onActivityResult = function(requestCode,resultCode,intent)

    if intent

      local cursor = this.getContentResolver().query(intent.getData(), nil, nil, nil, nil)
      cursor.moveToFirst()
      local idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA)
      fileSrc = cursor.getString(idx)
      GlideUtil.setImage(fileSrc, icon)

    end

  end

end

btn.onClick = function()

  local checkedList = {}

  for index,content in ipairs(ps)

    table.insert(checkedList,not not(pcs[content]))
  end

  MaterialAlertDialog(this)
  .setTitle(res.string.change_permission)
  .setMultiChoiceItems(pss,checkedList,function(dialog,which,isChecked)
    checkedList[which+1] = isChecked

  end)
  .setPositiveButton(res.string.ok,function()

    for index,content ipairs(ps)

      pcs[content]=checkedList[index]

    end

  end)
  .show()
end

pss={}
ps={}

for k,v pairs(permission_info)

  table.insert(ps,k)

end

table.sort(ps)

for k,v ipairs(ps)

  table.insert(pss,permission_info[v])

end

pcs={}

for k,v ipairs(info.user_permission or {})

  pcs[v]=true

end

local dump = function(t)

  local r = {}

  for k,v ipairs(t)

    r[k] = string.format('%q', v)

  end

  return table.concat(r, ",\n  ")

end

fab.onClick = function()

  if project_name.Text == ""

    project_name2.setError(TypefaceString(res.string.project_name_no))

   elseif project_package.Text == ""

    project_package2.setError(TypefaceString(res.string.project_package_no))

   else

    local rs = {}

    for n=1,#ps

      if pcs[ps[n]]

        table.insert(rs,ps[n])

      end

    end

    if File(luaproject .. "/config.json").isFile()

      local f = io.open(luaproject .. "/config.json","w")
      f:write(string.format([[{

  "label": "%s",
  "package": "%s",

  "versionName": "%s",
  "versionCode": "%s",

  "minSdkVersion": %s,
  "targetSdkVersion": %s,

  "debugmode": %s,
  "debuggermode": %s,

  "user_permission": [
  %s
  ],

  "skip_compilation": [
  %s
  ]

}]],
      project_name.Text,
      project_package.Text,
      project_appver.Text,
      project_appcode.Text,
      (project_sdk.Text):match("(.+)%/"),
      (project_sdk.Text):match("%/(.+)"),
      debugmode2.isChecked(),
      debuggermode,
      dump(rs),
      dump(skip)
      ))
      f:close()

     else

      local f = io.open(luaproject .. "/init.lua","w")
      f:write(string.format([[--名称
appname="%s"
--包名
packagename="%s"
--版本
appver="%s"
--版本号
appcode="%s"
--SDK
appsdk="%s"
--调试模式
debugmode=%s
--调试面板模式(1/2)
debuggermode=%s
--应用权限
user_permission={
  %s
}
--跳过编译
skip_compilation={
  %s
}]],
      project_name.Text,
      project_package.Text,
      project_appver.Text,
      project_appcode.Text,
      (project_sdk.Text):match("%/(.+)"),
      debugmode2.isChecked(),
      debuggermode,
      dump(rs),
      dump(skip)
      ))
      f:close()

    end



    if fileSrc ~= nil

      LuaUtil.copyDir(fileSrc, luaproject .. "/icon.png")

    end

    this.result { project_name.Text }

  end

end

ChangeUtil.EditTextChanged({project_name,project_package},{project_name2,project_package2})