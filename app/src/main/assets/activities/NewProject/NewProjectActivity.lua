require "environment"
local StaggeredGridLayoutManager = bindClass "androidx.recyclerview.widget.StaggeredGridLayoutManager"
local File = bindClass "java.io.File"
local Intent = bindClass "android.content.Intent"
local MediaStore = bindClass "android.provider.MediaStore"
local GlideUtil = require "mods.utils.GlideUtil"
local ChangeUtil = require "mods.utils.ChangeUtil"
local LuaRecyclerAdapter = require "LuaRecyclerAdapter"
local ProgressMaterialAlertDialog = require "mods.dialog.ProgressMaterialAlertDialog"

local Template_name = "Default"

this {
  Title = res.string.newproject,
  ContentView = res.view.newproject_layout,
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

local data = require "activities.NewProject.NewProjectActivity$data"

adapter = LuaRecyclerAdapter(data, res.layout.newproject_item,
{
  onBindViewHolder = function(viewHolder, pos, views, currentData)

    if currentData.name == Template_name

      views.check.setVisibility(0)

     else

      views.check.setVisibility(8)

    end

    views.template_name.setText(currentData.name)

    GlideUtil.setImage(res.drawable[""..currentData.src..""], views.template_icon)

    views.card.onClick = function()

      Template_name = currentData.name
      adapter.notifyDataSetChanged()

    end

  end
})

recyclerView
.setAdapter(adapter)
.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))

function createNewProject()

  projectNumber = projectNumber + 1
  checkProjectExistence(projectNumber)

end

function setProjectDetails(projectName)

  project_name.setText(projectName)
  project_package.setText(string.lower("com.mycompany." .. projectName))

end

function checkProjectExistence(projectNumber)

  local projectPath = PathUtil.project_dir.."/MyLuaApp" .. tostring(projectNumber)

  if File(projectPath).isDirectory()
    createNewProject()
   else
    setProjectDetails("MyLuaApp" .. tostring(projectNumber))
  end

end

recyclerView.post{
  run = function()

    projectNumber = 1
    checkProjectExistence(projectNumber)

  end
}

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

local ReplaceFileString = function(path,str1,str2)

  if path

    local path=tostring(path)
    local text=io.open(path):read("*a")
    io.open(path,"w+"):write(tostring(text:gsub(str1,str2))):close()

   else

    return false

  end

end

fab.onClick = function()

  local projectDir = PathUtil.project_dir .. "/" .. project_name.Text
  local appName = project_name.Text
  local packageName = project_package.Text

  if appName == ""

    project_name2.setError(TypefaceString(res.string.project_name_no))

   elseif packageName == ""

    project_package2.setError(TypefaceString(res.string.project_package_no))

   elseif File(projectDir).exists()

    project_name2.setError(TypefaceString(res.string.project_name_exists))

   elseif File(projectDir).mkdirs()

    local Awaiting = ProgressMaterialAlertDialog(this).show()

    this.newTask(function(this, Template_name, projectDir, appName, packageName, res, ReplaceFileString, fileSrc, LuaFileUtil)

      local LuaFileUtil = require "mods.utils.LuaFileUtil"
      LuaFileUtil.unZip(this.getLuaDir() .. "/mods/templates/" .. Template_name .. ".zip", projectDir .. "/")

      ReplaceFileString(projectDir .. "/main.lua", "%$AppName%$", appName)
      ReplaceFileString(projectDir .. "/main.lua", "%$PackageName%$", packageName)
      ReplaceFileString(projectDir .. "/config.json", "%$AppName%$", appName)
      ReplaceFileString(projectDir .. "/config.json", "%$PackageName%$", packageName)

      if fileSrc

        LuaFileUtil.copyFile(fileSrc, projectDir .. "/icon.png")

      end

      end,function()

      Awaiting.dismiss()

      this.result { res.string.create_ok }

      finish()

    end).execute({this, Template_name, projectDir, appName, packageName, res, ReplaceFileString, fileSrc, LuaFileUtil})


   else



  end

end

ChangeUtil.EditTextChanged({project_name,project_package},{project_name2,project_package2})