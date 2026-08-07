require "environment"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local LuaMaterialDialog = bindClass "com.jesse205.androluax.LuaMaterialDialog"
local ColorUtil = require "mods.utils.ColorUtil"
BottomSheetDialog = require "mods.dialog.BottomSheetDialog"
MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
mods = require "activities.LayoutHelper.LayoutHelperActivity$1"
method = require "activities.LayoutHelper.LayoutHelperActivity$2"
tools = require "activities.LayoutHelper.LayoutHelperActivity$xml2table"
loadlayout2 = require "activities.LayoutHelper.LayoutHelperActivity$loadlayout"

luadir, luapath = ...

luadir = luadir or luapath:gsub("/[^/]+$", "")

package.path = package.path .. ";" .. luadir .. "/?.lua;"

layout = {
  main = {
    LinearLayoutCompat,
    orientation="vertical",
    layout_width="match_parent",
    layout_height="match_parent",
  },
}

onCreateOptionsMenu = function(menu)

  menu.add(setFontSize(TypefaceString(res.string.copy), TextSize + 2))
  .onMenuItemClick=function()

    this.getSystemService("clipboard").setText(mods.dumplayout2(layout.main))

    MyToast(res.string.copied)

  end

  menu.add(setFontSize(TypefaceString(res.string.editor),TextSize + 2))
  .onMenuItemClick=function()

    tools.Layout_edit(mods.dumplayout2(layout.main))

  end

  menu.add(setFontSize(TypefaceString(res.string.preview),TextSize + 2))
  .onMenuItemClick=function()

    tools.Layout_preview(mods.dumplayout2(layout.main))

  end

  menu.add(setFontSize(TypefaceString(res.string.colorpalette),TextSize + 2))
  .onMenuItemClick=function()

    ColorUtil.setPalette(nil, function(color)

      this.getSystemService("clipboard").setText(color)

    end)

  end

  if luapath:find("%.aly$")

    menu.add(setFontSize(TypefaceString(res.string.save),TextSize + 2))
    .onMenuItemClick=function()

      mods.save(mods.dumplayout2(layout.main))

      this.result { true }

      finish()

    end

  end

end

onOptionsItemSelected = function(item)

  if item.getItemId() == android.R.id.home

    getCheck(layout.main)

  end

end

getCheck = function(l)

  if luapath:find("%.aly$")

    MaterialAlertDialog(this)
    .setTitle(res.string.tip)
    .setMessage(res.string.ok_no_save_layout)
    .setPositiveButton(res.string.ok,function()

      mods.save(mods.dumplayout2(layout.main))
      this.result { true }

      finish()

    end)
    .setNegativeButton(res.string.no,finish)
    .show()

   else

    finish()

  end
end

local layout_main = layout.main

if luapath:find("%.aly$")

  local f = io.open(luapath)
  local s = f:read("*a")
  f:close()

  try

    layout.main = assert(loadstring("return "..s))()

    catch(e)

    this.result { e }

  end

end

setTitle = function (dialog, titleview, text)

  if this.getSharedData("layouthelper_dialog") == 1

    dialog.setTitle(setFontSize(TypefaceString(text), TextSize + 8))

   else

    titleview.setText(text)

  end

end

if this.getSharedData("layouthelper_dialog") == 1

  fd_dlg = LuaMaterialDialog(this)

  fd_list = fd_dlg.getListView()

 else

  fd_dlg, fd_dlg_views = BottomSheetDialog.showDialog(res.view.dialog_item, false)

  fd_list, fd_title = mDialogListView, mDialogTitle

end

checks = {}
checks.visibility = {"VISIBLE", "INVISIBLE", "GONE"}
checks.layout_width = {"match_parent", "wrap_content", "Fixed size..."}
checks.layout_height = {"match_parent", "wrap_content", "Fixed size..."}
checks.textStyle = {"bold", "italic", "bold|italic"}
checks.ellipsize = {"start", "end", "middle", "marquee"}
checks.singleLine = {"true", "false"}
checks.orientation = {"vertical", "horizontal"}
checks.gravity = {"left", "top", "right", "bottom", "start", "center", "end", "bottom|end", "end|center", "left|center", "top|center", "bottom|center"}
checks.layout_gravity = {"left", "top", "right", "bottom", "start", "center", "end", "bottom|end", "end|center", "left|center", "top|center", "bottom|center"}
checks.scaleType = {
  "matrix",
  "fitXY",
  "fitStart",
  "fitCenter",
  "fitEnd",
  "center",
  "centerCrop",
  "centerInside"
}

local rbs = {"layout_alignParentBottom", "layout_alignParentEnd", "layout_alignParentLeft", "layout_alignParentRight", "layout_alignParentStart", "layout_alignParentTop", "layout_centerHorizontal", "layout_centerInParent", "layout_centerVertical"}
local ris = {"layout_above", "layout_alignBaseline", "layout_alignBottom", "layout_alignEnd", "layout_alignLeft", "layout_alignRight", "layout_alignStart", "layout_alignTop", "layout_alignWithParentIfMissing", "layout_below", "layout_toEndOf", "layout_toLeftOf", "layout_toRightOf", "layout_toStartOf"}

for k, v ipairs(rbs)

  checks[v] = {"true", "false", "none"}

end

for k, v ipairs(ris)

  checks[v] = mods.checkid

end

checks.src = function()

  local src = {}

  mods.addDir(src, "", File(luadir))

  return src

end

fd_list.onItemClick = function(l, v, p, i)

  fd_dlg.dismiss()

  local fd = tostring(v.Text)

  if string.find(fd, " = ")

    fd = fd:gsub("% = .*", "")

  end

  if checks[fd]

    if type(checks[fd]) == "table"

      setTitle(check_dlg, check_title, fd)
      method.AdapterUtil(check_dlg, check_list, checks[fd])
      check_dlg.show()

     else

      setTitle(check_dlg, check_title, fd)
      method.AdapterUtil(check_dlg, check_list, checks[fd](fd))
      check_dlg.show()

    end

   else

    func[fd]()

  end
end

if this.getSharedData("layouthelper_dialog") == 1

  cd_dlg = LuaMaterialDialog(this)

  cd_list = cd_dlg.getListView()

 else

  cd_dlg = BottomSheetDialog.showDialog(res.view.dialog_item, false)

  cd_list, cd_title = mDialogListView, mDialogTitle

end

cd_list.onItemClick = function(l, v, p, i)

  method.getCurr(chids[p])
  cd_dlg.dismiss()

end

if this.getSharedData("layouthelper_dialog") == 1

  check_dlg = LuaMaterialDialog(this)

  check_list = check_dlg.getListView()

 else

  check_dlg = BottomSheetDialog.showDialog(res.view.dialog_item, false)

  check_list, check_title = mDialogListView, mDialogTitle

end

local Heavy_load_layout = function()

  local fld = (function() try return check_title.Text catch return check_dlg.Title end end)()
  local old = curr[tostring(fld)]

  curr[tostring(fld)] = v
  check_dlg.dismiss()

  local s, l = pcall(loadlayout2, layout.main, {})

  if s

    mods.ShowLayout(l)

   else

    curr[tostring(fld)] = old
    mods.getError(l)

  end

end

check_list.onItemClick = function(l, v, p, i)

  local v = tostring(v.Text)

  if #v == 0 or v == "none"

    v = nil

   elseif v == "GONE"

    v = View.GONE

    Heavy_load_layout()

   elseif v == "VISIBLE"

    v = View.VISIBLE

    Heavy_load_layout()

   elseif v == "INVISIBLE"

    v = View.INVISIBLE

    Heavy_load_layout()

   elseif v == "Fixed size..."

    check_dlg.dismiss()
    func[(function() try return check_title.Text catch return check_dlg.Title end end)()]()

   else

    local fld = (function() try return check_title.Text catch return check_dlg.Title end end)()
    local old = curr[tostring(fld)]

    curr[tostring(fld)] = v
    check_dlg.dismiss()

    local s, l = pcall(loadlayout2, layout.main, {})

    if s

      mods.ShowLayout(l)

     else

      curr[tostring(fld)] = old
      mods.getError(l)

    end

  end



end

local vipE = {
  "layout_width","layout_height","textSize","maxHeight","maxWidth","minWidth",
  "layout_margin","layout_marginLeft","layout_marginTop","layout_marginRight","layout_marginBottom",
  "padding","paddingLeft","paddingTop","paddingRight","paddingButtom","Rotation","RotationX","RotationY","CardElevation","radius"
}

local is_include = function(value, tab)

  for k,v ipairs(tab)

    if v == value

      return true

    end

  end

  return false

end

local EDIT = function(code)

  sfd_dlg = LuaMaterialDialog(activity)
  .setView(res.view.sfd_layout)
  .setPositiveButton(setFontSize(TypefaceString(res.string.ok), TextSize), ok )
  .setNegativeButton(setFontSize(TypefaceString(res.string.no), TextSize), nil)
  .setNeutralButton(setFontSize(TypefaceString(res.string.nothing), TextSize), none )

  if code == true

    root.setVisibility(0)

    fld_TRUE = true

    fld.addTextChangedListener{
      onTextChanged=function(s)

        try

          flds.setProgress(tointeger(tostring(string.sub(fld.Text,1,-3))))

        end

      end
    }

    flds.setOnSeekBarChangeListener{
      onProgressChanged=function()

        try

          fld.setText(flds.Progress .. string.sub(fld.Text,-2,-1))

        end

      end
    }

  end

end

func = {}
setmetatable(func, {__index = function(t, k)
    return function()

      if is_include(k,vipE)

        if tostring(curr[k]):find("^[0-9]*dp$") or tostring(curr[k]):find("^[0-9]*sp$") or tostring(curr[k]):find("^[0-9]*%%w$") or tostring(curr[k]):find("^[0-9]*%%h$")

          EDIT(true)

          fld.setText(curr[k])

         elseif curr[k] == nil or curr[k] == ""

          EDIT(true)

          if k == "textSize"

            fld.setText("10sp")

           else

            fld.setText("10dp")

          end

         else

          EDIT(false)

          fld.setText(curr[k] or "")

        end

       else

        EDIT(false)

        fld.setText(curr[k] or "")

      end

      sfd_dlg.setTitle(setFontSize(TypefaceString(k), TextSize + 8))
      sfd_dlg.show()

    end
  end
})

func[res.string.add] = function()

  setTitle(add_dlg, add_title, tostring(currView.Class.getSimpleName()))

  for n = 0, #ns-1

    if n~=i

      el.collapseGroup(n)

    end

  end

  add_dlg.show()

end

local delete_dontrol = function(gp)

  for k, v ipairs(gp)

    if v == curr

      table.remove(gp, k)

      break

    end

  end

  mods.ShowLayout(loadlayout2(layout.main, {}))

end

func[res.string.delete] = function()

  local gp = currView.Parent.Tag

  if gp == nil

    MyToast(res.string.no_d_top)

    return

  end

  if not this.getSharedData("deleting_control")

    delete_dontrol(gp)

   else

    MaterialAlertDialog(this)
    .setTitle(res.string.tip)
    .setMessage((res.string.ok_delete_no):format(currView.Class.getSimpleName()))
    .setPositiveButton(res.string.ok, function()
      delete_dontrol(gp)
    end)
    .show()

  end
end


func[res.string.parent_control] = function()

  local p = currView.Parent

  if p.Tag == nil

    MyToast(res.string.now_f_top)

   else

    method.getCurr(p)

  end
end

chids = {}

func[res.string.child_control] = function()

  chids = {}
  local arr = {}

  for n = 0, currView.ChildCount-1

    local chid = currView.getChildAt(n)

    chids[n] = chid

    table.insert(arr, chid.Class.getSimpleName())

  end

  setTitle(cd_dlg, cd_title, tostring(currView.Class.getSimpleName()))
  method.AdapterUtil(cd_dlg, cd_list, arr)
  cd_dlg.show()

end

if this.getSharedData("layouthelper_dialog") == 1

  add_dlg = LuaMaterialDialog(this)

  el = ExpandableListView(this)

  el.setDividerHeight(0)

  add_dlg.setView(el)

 else

  add_dlg = BottomSheetDialog.showDialog(res.view.dialog_expandablelistview, false)

  el, add_title = mDialogListView, mDialogTitle

end

mAdapter = ArrayExpandableListAdapter(this)

for k, v ipairs(ns)

  mAdapter.add(v, wds[k])

end

el.setAdapter(mAdapter)

el.onChildClick = function(l, v, g, c)

  local w = {_G[wds[g+1][c+1]]}

  table.insert(curr, w)

  local s, l = pcall(loadlayout2, layout.main, {})

  if s

    mods.ShowLayout(l)

   else

    table.remove(curr)
    mods.getError(l)

  end

  add_dlg.dismiss()

end

ok = function()

  local v = tostring(fld.Text)

  if #v == 0

    v = nil

  end

  local fld = sfd_dlg.Title
  local old = curr[tostring(fld)]

  curr[tostring(fld)] = v

  try


    mods.ShowLayout(loadlayout2(layout.main))

    if loadlayout_error == true

      curr[tostring(fld)] = old

    end

    catch(e)

    curr[tostring(fld)] = old

    mods.getError(e)

  end

end

none = function()

  local old = curr[tostring(sfd_dlg.Title)]

  curr[tostring(sfd_dlg.Title)] = nil

  mods.ShowLayout(loadlayout2(layout.main))

  if loadlayout_error == true

    curr[tostring(fld)] = old

  end

end

onStart = function()

  try

    mods.ShowLayout(loadlayout2(layout.main))

    catch(e)

    this.result { e }

  end

end

onKeyDownX(function()

  getCheck(layout.main)

end)