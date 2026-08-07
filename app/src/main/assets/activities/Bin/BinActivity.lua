require "environment"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local PopupRecyclerAdapter = bindClass "github.znzsofficial.adapter.PopupRecyclerAdapter"

local luaproject = ...

this {
  Title = res.string.build_project,
  ContentView = res.view.bin_layout,
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

newInstance("me.zhanghai.android.fastscroll.FastScrollerBuilder", recyclerView)
.useMd2Style()
.setPadding(0,dp2px(8),dp2px(2),dp2px(8))
.build()

local data = {}

local adapter = PopupRecyclerAdapter(this, PopupRecyclerAdapter.PopupCreator({

  getItemCount = function()

    return #data

  end,

  getItemViewType = function()

    return 0

  end,

  getPopupText = function(view, position)

    return ""--utf8.sub(data[position + 1].content, 1 , 1)

  end,

  onViewRecycled = function(holder)

  end,

  onCreateViewHolder = function(parent,viewType)

    local views = {}
    local holder = LuaCustRecyclerHolder(loadlayout(res.layout.opensourcelicense_item, views))
    holder.Tag = views
    return holder

  end,

  onBindViewHolder = function(holder,position)

    local views = holder.Tag
    local currentData = data[position+1]

    views.license.setVisibility(8)

    views.name.setText(currentData).setTextSize(TextSize)

    views.message.setVisibility(8)

    views.cardView.onClick = function()


    end



  end
}))

recyclerView
.setAdapter(adapter)
.setLayoutManager(LinearLayoutManager())


update = function(message)

  local message = tostring(message)

  table.insert(data, message)

  adapter.notifyDataSetChanged()

  recyclerView.scrollToPosition(adapter.getItemCount() - 1)

end

local callback = function(s)

  update(s)

  activity.installApk(s:match("：(.+)"))

end

local binapk = function(luapath, apkpath, PathUtil)

  local dofile2 = function(path)

    local File = luajava.bindClass "java.io.File"

    if File(path .. "/config.json").isFile()

      e, s = pcall(dofile, path .. "/config.json")
      if !s return false end

      return true, {
        label = s.label,
        package = s.package,
        versionName = s.versionName,
        versionCode = s.versionCode,
        minSdkVersion = s.minSdkVersion,
        targetSdkVersion = s.targetSdkVersion,
        debugmode = s.debugmode,
        debuggermode = s.debuggermode,
        user_permission = s.user_permission,
        skip_compilation = s.skip_compilation
      }

     elseif File(path .. "/init.lua").isFile()

      e, s = pcall(dofile, path .. "/init.lua")
      if !e return false end

      return true, {
        label = appname,
        package = packagename,
        versionName = appver,
        versionCode = appcode,
        minSdkVersion = "23",
        targetSdkVersion = appsdk,
        debugmode = debugmode,
        debuggermode = debuggermode,
        user_permission = user_permission,
        skip_compilation = skip_compilation
      }

    end

  end

  require "import"

  import "console"

  import "mods.utils.ApkSignerUtil"

  res = require "mods.utils.ResUtil"

  local is_compilation = activity.getSharedData("compileLua")

  import "java.util.zip.ZipOutputStream"
  import "android.net.Uri"
  import "java.io.File"
  import "android.widget.Toast"
  import "java.util.zip.CheckedInputStream"
  import "java.io.FileInputStream"
  import "android.content.Intent"
  import "java.security.Signer"
  import "java.util.ArrayList"
  import "java.io.FileOutputStream"
  import "java.io.BufferedOutputStream"
  import "java.util.zip.ZipInputStream"
  import "java.io.BufferedInputStream"
  import "java.util.zip.ZipEntry"
  import "android.app.ProgressDialog"
  import "java.util.zip.CheckedOutputStream"
  import "java.util.zip.Adler32"
  import "com.androlua.LuaUtil"
  import "com.androlua.ZipUtil"
  import "net.lingala.zip4j.ZipFile"
  import "com.nwdxlgzs.utils.xml.Encoder"
  import "com.nwdxlgzs.utils.xml.AXmlResourceParser"
  import "java.io.FileInputStream"
  import "java.io.StringReader"
  import "java.io.ByteArrayOutputStream"
  import "javax.xml.parsers.DocumentBuilderFactory"
  import "javax.xml.transform.dom.DOMSource"
  import "javax.xml.transform.TransformerFactory"
  import "javax.xml.transform.stream.StreamResult"
  import "org.xml.sax.InputSource"
  import "java.io.ByteArrayInputStream"
  import "net.lingala.zip4j.model.ZipParameters"

  luapath = luapath .. "/"

  local b = byte[2 ^ 16]

  local function copy(input, output)

    LuaUtil.copyFile(input, output)

    input.close()

  end

  local function copy2(input, output)

    LuaUtil.copyFile(input, output)

  end

  local temp = File(apkpath).getParentFile()

  if not temp.exists() and not temp.mkdirs()

    return res.string.create_folder .. "“" .. temp.getName() .. "”" .. res.string.fail

  end

  local tmp = activity.getLuaPath("tmp.apk")
  local info = activity.getApplicationInfo()
  local ver = activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0).versionName
  local code = activity.getPackageManager().getPackageInfo(activity.getPackageName(), 0).versionCode
  local zipFile = File(info.publicSourceDir)
  local fis = FileInputStream(zipFile)
  local zis = ZipInputStream(BufferedInputStream(fis))
  local fot = FileOutputStream(tmp)
  local out = ZipOutputStream(BufferedOutputStream(fot))
  local f = File(luapath)
  local errbuffer = {}
  local replace = {}
  local checked = {}
  local lualib = {}
  local md5s = {}
  local compilation = {}

  local libs = luajava.astable(File(activity.ApplicationInfo.nativeLibraryDir).list())

  for k, v ipairs(libs)
    replace[v] = true
  end

  local mdp = activity.Application.MdDir

  local function getmodule(dir)

    local mds = File(activity.Application.MdDir .. dir).listFiles()

    mds = luajava.astable(mds)

    for k, v ipairs(mds)

      if mds[k].isDirectory()

        getmodule(dir .. mds[k].Name .. "/")

       else

        mds[k] = "lua" .. dir .. mds[k].Name

        replace[mds[k]] = true

      end

    end

  end

  update(res.string.sorting_library_files)
  getmodule("/")

  local function checklib(path)

    try

      if checked[path]
        return
      end

      checked[path] = true
      local file = io.open(path)
      local str = file:read("*a")
      file:close()

      local function processImport(m1, m2, m3)

        local cp = string.format("lib%s.so", m1)
        local lp

        if m3 ~= ""

          lp = string.format("lua/%s/%s/%s.lua", m1, m2, m3)

         elseif m2 ~= ""

          lp = string.format("lua/%s/%s.lua", m1, m2)

         else

          lp = string.format("lua/%s.lua", m1)

        end

        if replace[cp]

          replace[cp] = false
          update(res.string.reserve .. "：" .. lp)

        end

        if replace[lp]

          local path

          if m3 ~= ""

            path = mdp .. "/" .. m1 .. '/' .. m2 .. '/' .. m3 .. ".lua"

            m1 = m1 .. '/' .. m2 .. '/' .. m3

           elseif m2 ~= ""

            path = mdp .. "/" .. m1 .. '/' .. m2 .. ".lua"

            m1 = m1 .. '/' .. m2

           else

            path = mdp .. "/" .. m1 .. ".lua"

          end

          checklib(path)
          replace[lp] = false
          update(res.string.reserve .. "：" .. lp)
          lualib[lp] = path

        end

      end

      for m1, m2, m3 str:gmatch("require *%(? *\"([%w_]+)%.?([%w_]*)%.?([%w_]*)")

        processImport(m1, m2, m3)

      end

      for m1, m2, m3 str:gmatch("import *%(? *\"([%w_]+)%.?([%w_]*)%.?([%w_]*)")

        processImport(m1, m2, m3)

      end

      for statements str:gmatch("imports %[%[(.-)%]%]")

        for s statements:gmatch("[^\n]+")

          local s = s:match("^%s*(.-)%s*$")

          if s ~= "" and not s:find("^%-%-")

            local s = "import " .. "\"" .. s .. "\""

            for m1, m2, m3 s:gmatch("import *%(? *\"([%w_]+)%.?([%w_]*)%.?([%w_]*)")

              processImport(m1, m2, m3)

            end

          end

        end

      end

      catch(e)

      update(res.string.now_error .. "：" .. e)

    end

  end

  local dirtemp = {}

  local function customLualibs(p)

    local luaname = ""
    local lualibsDir = luajava.astable(File(p).listFiles() or File{})

    for name, v pairs(lualibsDir)

      if v.isFile() and tostring(v.name):find("%.lua$")

        luaname = table.concat(dirtemp, "/")

        if table.size(dirtemp) > 0

          luaname = table.concat(dirtemp, "/") .. "/"

        end

        local luapools = "lua/" .. luaname .. tostring(v.name)

        lualib[luapools] = tostring(v)

       elseif v.isDirectory()

        table.insert(dirtemp, tostring(v.name))

        customLualibs(tostring(v))

        dirtemp = {}

      end

    end

  end

  replace["libluajava.so"] = false

  success, config = dofile2(luapath)

  if config.skip_compilation

    for k, v ipairs(config.skip_compilation)

      table.insert(compilation, v)

    end

  end

  project_path = luapath

  function is_include(value, tab)

    for k, v ipairs(tab)

      if project_path .. v == value

        return true

      end

    end

    return false

  end

  local function addDir(out, dir, f)

    local entry = ZipEntry("assets/" .. dir)
    out.putNextEntry(entry)
    local ls = f.listFiles() or {}

    for n = 0, #ls - 1

      local name = ls[n].getName()

      if name == ".using" or name:find("%.apk$") or name:find("%.luac$") or name:find("^%.") or name:find("%.java$")

       elseif name:find("%.lua$")

        checklib(luapath .. dir .. name)
        Compile_TRUR = true

        if !is_include(tostring(luapath .. dir .. name),compilation)

          if is_compilation == true or is_compilation == nil

            path, err = console.build(luapath .. dir .. name)

           elseif is_compilation == false

            path = luapath .. dir .. name
            Compile_TRUR = false

          end

         else

          path = luapath .. dir .. name

          Compile_TRUR = false

        end

        if path

          if replace["assets/" .. dir .. name]

            table.insert(errbuffer, dir .. name .. "/.aly")

            update(res.string.file_duplicate_name .. "：\n" .. err)

          end

          local entry = ZipEntry("assets/" .. dir .. name)
          out.putNextEntry(entry)

          replace["assets/" .. dir .. name] = true

          copy(FileInputStream(File(path)), out)

          table.insert(md5s, LuaUtil.getFileMD5(path))

          if Compile_TRUR

            os.remove(path)

            update(res.string.compile_ok .. "：" .. dir .. name)

          end

         else

          table.insert(errbuffer, err)

          update(res.string.compile_no .. "：\n" .. err)

        end

       elseif name:find("%.aly$")

        checklib(luapath .. dir .. name)

        Compile_TRUR = true

        if !is_include(tostring(luapath .. dir .. name),compilation)

          if is_compilation == true or is_compilation == nil

            path, err = console.build_aly(luapath .. dir .. name)

            name = name:gsub("aly$", "lua")

           elseif is_compilation == false

            path = luapath .. dir .. name

            Compile_TRUR = false

            name = name:gsub("aly$", "aly")

          end

         else

          path = luapath .. dir .. name
          Compile_TRUR = false
          name = name:gsub("aly$", "aly")

        end

        if path

          if replace["assets/" .. dir .. name]

            table.insert(errbuffer, dir .. name .. "/.aly")

            update(res.string.reserve .. "：\n" .. err)

          end

          local entry = ZipEntry("assets/" .. dir .. name)
          out.putNextEntry(entry)

          replace["assets/" .. dir .. name] = true

          copy(FileInputStream(File(path)), out)

          table.insert(md5s, LuaUtil.getFileMD5(path))

          if Compile_TRUR

            os.remove(path)

            update(res.string.compile_ok .. "：" .. dir .. name)

          end

         else

          table.insert(errbuffer, err)

          update(res.string.compile_no .. "：\n" .. err)

        end

       elseif ls[n].isDirectory()

        addDir(out, dir .. name .. "/", ls[n])

       else

        local entry = ZipEntry("assets/" .. dir .. name)
        out.putNextEntry(entry)

        replace["assets/" .. dir .. name] = true

        copy(FileInputStream(ls[n]), out)

        table.insert(md5s, LuaUtil.getFileMD5(ls[n]))

      end
    end
  end

  local function customSolibs64(p)

    update(res.string.writing_so_dependency_library)

    local lualibsDir = luajava.astable(File(p).listFiles() or {})

    for _, v pairs(lualibsDir)

      if v.isFile() and v.name:find("%.so$")

        local spath = "lib/arm64-v8a/" .. v.name
        local entry = ZipEntry(spath)

        out.putNextEntry(entry)

        replace[spath] = true

        copy(FileInputStream(tostring(v)), out)

        table.insert(md5s, LuaUtil.getFileMD5(tostring(v)))

       elseif v.isDirectory()

        customSolibs64(tostring(v))

      end
    end
  end

  if File(PathUtil.solibs_dir).isDirectory()

    customSolibs64(PathUtil.solibs_dir)

  end

  if File(PathUtil.lualibs_dir).isDirectory()

    customLualibs(PathUtil.lualibs_dir)

  end

  if f.isDirectory()

    update(res.string.compiling)

    local ss, ee = pcall(addDir, out, "", f)

    if not ss

      table.insert(errbuffer, ee)

      update(res.string.compile_no .. "：\n" .. ee)

    end

    local wel = File(luapath .. "icon.png")

    if wel.exists()

      local entry = ZipEntry("res/drawable/icon.png")
      out.putNextEntry(entry)

      replace["res/drawable/icon.png"] = true

      copy(FileInputStream(wel), out)

     else

      update(res.string.warning_icon)

    end

   else

    update(res.string.file_folder_not_found .. "：" .. tostring(f))

  end

  update(res.string.compiling_library_films)

  for name, v pairs(lualib)

    Compile_TRUR = true

    if is_compilation == true or is_compilation == nil

      path, err = console.build(v)

     elseif is_compilation == false

      path = v

      Compile_TRUR = false

    end

    if path

      local entry = ZipEntry(name)
      out.putNextEntry(entry)

      copy(FileInputStream(File(path)), out)

      table.insert(md5s, LuaUtil.getFileMD5(path))

      if Compile_TRUR

        os.remove(path)

        update(res.string.compile_ok .. "：" .. name)

      end

     else

      table.insert(errbuffer, err)

      update(res.string.compile_no .. "：\n" .. err)

    end

  end

  function touint32(i)
    local code = string.format("%08x", i)
    local uint = {}
    for n code:gmatch(" .. ")
      table.insert(uint, 1, string.char(tonumber(n, 16)))
    end
    return table.concat(uint)
  end

  local hasExecuted = false

  update(res.string.packing)

  local entry = zis.getNextEntry()

  while entry

    local name = entry.getName()
    local lib = name:match("([^/]+%.so)$")

    if replace[name]
     elseif lib and replace[lib]
     elseif name:find("^assets/")
     elseif name:find("^lua/")
     elseif name:find("META%-INF")
     elseif !name:find("%a")

     else

      local entry = ZipEntry(name)
      out.putNextEntry(entry)

      if entry.getName() == "AndroidManifest.xml"

       elseif not entry.isDirectory()

        copy2(zis, out)

      end

    end

    entry = zis.getNextEntry()

  end

  out.setComment(table.concat(md5s))
  zis.close()
  out.closeEntry()
  out.close()

  if #errbuffer == 0

    update(res.string.modifying_package_information)

    update(res.string.modified_ok .. "：icon")

    local tmp2 = activity.getLuaDir("tmp")

    os.remove(tmp2)

    ZipUtil.unzip(tmp, tmp2)

    os.remove(tmp)

    LuaUtil.copyDir(activity.getLuaDir("keys/AndroidManifest.xml"), tmp2 .. "/AndroidManifest.xml")

    local containsChar = function(str, char)

      return string.find(str, char) ~= nil

    end

    local isComplete = function(str,z)

      if z

        return containsChar(str,"android.permission.") and str or "android.permission." .. str

       else

        return containsChar(str,"android.permission.") and str:match("android%.permission%.(.+)") or str

      end

    end

    local zip = ZipFile(tmp2 .. "/AndroidManifest.zip")

    local generateFromBaseAxmlInputStream = function(ins)

      local xmlStr = AXmlResourceParser.decodeStream(ins)

      :gsub(activity.packageName, config.package)

      local doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(InputSource(StringReader(xmlStr)))

      update(res.string.modified_ok .. "：versionName " .. config.versionName)

      update(res.string.modified_ok .. "：versionCode " .. config.versionCode)

      local root = doc.documentElement
      .setAttribute("android:versionName", tostring(config.versionName))
      .setAttribute("android:versionCode", tostring(config.versionCode))

      update(res.string.modified_ok .. "：minSdkVersion " .. config.minSdkVersion)

      update(res.string.modified_ok .. "：targetSdkVersion " .. config.targetSdkVersion)

      root.getElementsByTagName("uses-sdk").item(0)
      .setAttribute("android:minSdkVersion", tostring(config.minSdkVersion))
      .setAttribute("android:targetSdkVersion", tostring(config.targetSdkVersion))

      update(res.string.modified_ok .. "：label " .. config.label)

      root.getElementsByTagName("application").item(0)
      .setAttribute("android:label", config.label)

      root.getElementsByTagName("activity").item(0)
      .setAttribute("android:label", config.label)

      root.getElementsByTagName("activity").item(1)
      .setAttribute("android:label", config.label)

      root.getElementsByTagName("activity").item(2)
      .setAttribute("android:label", config.label)

      root.getElementsByTagName("activity").item(3)
      .setAttribute("android:label", config.label)



      local permissionNodes = root.getElementsByTagName("uses-permission")

      for i = 0, permissionNodes.length - 1

        root.removeChild(permissionNodes.item(i))

      end

      for _, v pairs(config.user_permission)

        local node = doc.createElement("uses-permission").setAttribute("android:name",isComplete(v,true))

        root.appendChild(node)

      end

      local ous = ByteArrayOutputStream()
      TransformerFactory.newInstance().newTransformer().setOutputProperty("encoding", "UTF-8").transform(DOMSource(root), StreamResult(ous))

      local bytes = Encoder().encodeString(activity, ous.toString())
      ous.close()

      baseApk, xmlStr = nil,nil
      doc, root, permissionNodes = nil,nil,nil
      ous = nil

      return bytes

    end

    local axmlFiles = tmp2 .. "/AndroidManifest.xml"

    local axmlIns = FileInputStream(axmlFiles)

    local generatedAxmlBytes = generateFromBaseAxmlInputStream(axmlIns)

    axmlIns.close()

    local inputStream = ByteArrayInputStream(generatedAxmlBytes)

    local zipParameters = ZipParameters()
    zipParameters.setFileNameInZip("AndroidManifest.xml")

    zip.addStream(inputStream, zipParameters)
    inputStream.close()

    ZipUtil.unzip(tmp2 .. "/AndroidManifest.zip", activity.getLuaDir("tmp"))

    os.remove(tmp2 .. "/AndroidManifest.zip")

    ZipUtil.zip(tmp2, activity.getLuaDir())

    os.rename(activity.getLuaDir("tmp.zip"), activity.getLuaDir() .. "/tmp.apk")

    os.execute("rm -rf " .. tmp2)

    ApkSignerUtil.sign()

    ApkSignerUtil.signWithDefaultSignature(activity.getLuaDir() .. "/tmp.apk", apkpath)

    os.execute("rm -rf " .. activity.getLuaDir() .. "/tmp.apk")

    return res.string.bin_ok .. "：" .. apkpath

   else

    os.remove(tmp)

    return res.string.bin_no .. "：\n " .. table.concat(errbuffer, "\n")

  end

end

local success, config = dofile2(luaproject)

if success

  this.newTask(binapk, update, callback).execute({luaproject, this.getLuaExtPath("bin",config.label .. "_" .. tostring(config.versionName) .. ".apk"), PathUtil})

 else

  update(res.string.engineering_configuration_file_error)

end