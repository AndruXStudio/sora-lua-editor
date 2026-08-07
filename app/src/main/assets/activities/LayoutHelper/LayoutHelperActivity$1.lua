local _M = {}
local Paint = bindClass "android.graphics.Paint"
local System = bindClass "java.lang.System"
local MotionEvent = bindClass "android.view.MotionEvent"
local Snackbar = bindClass "com.google.android.material.snackbar.Snackbar"
local LuaDrawable = bindClass "com.androlua.LuaDrawable"
local TypedValue = bindClass "android.util.TypedValue"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local DrawableUtil = require "mods.utils.DrawableUtil"

_M.ShowLayout = function(sub)

  this {
    Title = setFontSize(TypefaceString(res.string.layout_helper), TextSize + 8),
    ContentView = res.view.layouthelper_layout,
    SupportActionBar = toolbar
  }
  .getSupportActionBar()
  {
    DisplayHomeAsUpEnabled = true
  }

  Linearx.addView(sub)

  return _M

end

_M.addDir = function(out, dir, f)

  local ls = f.listFiles()

  for n = 0, #ls - 1

    local name = ls[n].getName()

    if ls[n].isDirectory()

      _M.addDir(out, dir .. name .. "/", ls[n])

     elseif name:find("%.j?pn?g$")

      table.insert(out, dir .. name)

    end

  end

end

_M.checkid = function()

  local cs = {}
  local parent = currView.Parent.Tag

  for k,v ipairs(parent)

    if v==curr

      break

    end

    if type(v)=="table" and v.id

      table.insert(cs, v.id)

    end

  end

  return cs

end

_M.getError = function(l)

  MaterialAlertDialog(this)
  .setTitle(res.string.tip)
  .setMessage(l)
  .setPositiveButton(res.string.ok)
  .show()

end

local dumparray = function(arr)

  local ret={}

  table.insert(ret,"{\n")

  for k,v in ipairs(arr)

    table.insert(ret,string.format("\"%s\";\n",v))

  end

  table.insert(ret,"},\n")

  return table.concat(ret)

end

dumplayout = function(t)

  table.insert(ret,"{\n")

  table.insert(ret,tostring(t[1].getSimpleName()..";\n"))

  for k,v pairs(t)

    if type(k)=="number"

     elseif type(v)=="table"

      table.insert(ret,k.."="..dumparray(v))

     elseif type(v) == "string"

      if v:find("[\"\'\r\n]")

        table.insert(ret,string.format("%s=[==[%s]==];\n",k,v))

       else

        table.insert(ret,string.format("%s=\"%s\";\n",k,v))

      end

     else

      table.insert(ret,string.format("%s=%s,\n",k,tostring(v)))

    end

  end

  for k,v ipairs(t)

    if type(v)=="table"

      dumplayout(v)

    end

  end

  table.insert(ret,"};\n")

end

_M.dumplayout2 = function(t)

  ret = {}

  dumplayout(t)

  return table.concat(ret)

end

_M.save = function(s)

  local f = io.open(luapath,"w")

  f:write(s)

  f:close()

  return _M

end

--[[local is_clicking = false

local click_info_init = function()

  click_info = {
    start = {
      x = 0,
      y = 0,
    },

    start_time = 0,
    now_click = nil,
    mode = 1,
    now_view = nil,
  }

end

local holding_view = false

local clicking_background = function(c,p)

  p.color = ({0,0,0,0})

  [click_info.mode]

  if click_info.now_click

    c.drawRect(0,0,c.width,c.height,p)

    if click_info.mode == 1 and (System.currentTimeMillis() - click_info.start_time) < 750

      p.color = tonumber(0)
      c.drawRect(0,0,(c.width/750)*(System.currentTimeMillis() - click_info.start_time),c.height,p)

      if click_info.now_view

        click_info.now_view.invalidate()

      end

     elseif click_info.mode == 1

      p.color = tonumber(0)
      c.drawRect(0,0,c.width,c.height,p)

    end

    p.style = Paint.Style.STROKE
    p.setStrokeWidth(20)
    p.setStrokeJoin(Paint.Join.ROUND)
    p.setTextSize(40)
    p.setFakeBoldText(true)
    p.color = tonumber(Colors.colorPrimary)
    c.drawRect(0,0,c.width,c.height,p)
    p.setStyle(Paint.Style.FILL)

  end
end

clicking_background_drawable = LuaDrawable(clicking_background)
]]

_M.onTouch = function(v,e)

  if e.getAction()==MotionEvent.ACTION_DOWN
    
    method.getCurr(v)
    
    return true
    
  end

--[[if is_clicking and e.getAction() == MotionEvent.ACTION_UP

    method.getCurr(v)
    fd_dlg.dismiss()

    v.foreground = nil

    is_clicking = false

    if (System.currentTimeMillis() - click_info.start_time) > 750

      holding_view = true

    end

    method.getCurr(v)

   elseif (not is_clicking) and e.getAction() == MotionEvent.ACTION_DOWN

    holding_view = false
    v.foreground = clicking_background_drawable

    click_info_init()
    click_info.now_view = v
    click_info.start = {
      x = e.rawX,
      y = e.rawY,
    }
    click_info.start_time = System.currentTimeMillis()
    click_info.now_click = v
    is_clicking = true

    return true

   elseif is_clicking and e.getAction() == MotionEvent.ACTION_MOVE

    local offset = this.getWidth()/3

    if
      math.abs(e.rawX - click_info.start.x) > offset or
      math.abs(e.rawY - click_info.start.y) > offset

      is_clicking = false
      v.foreground = nil

     else

      if e.rawY - click_info.start.y > offset*0.3

        click_info.mode = 3
        v.invalidate()

       elseif e.rawY - click_info.start.y < -(offset*0.3)

        click_info.mode = 2
        v.invalidate()

       elseif e.rawX - click_info.start.x < -(offset*0.3)

        click_info.mode = 4
        v.invalidate()

       else

        if click_info.mode ~= 1

          click_info.start_time = System.currentTimeMillis()

        end

        click_info.mode = 1

        v.invalidate()

      end
    end

    return true

  end]]

end

local dm = this.getResources().getDisplayMetrics()

local dp = function(n)

  return TypedValue.applyDimension(1,n,dm)

end

local to = function(n)

  return string.format("%ddp",n//dn)

end

local dn = dp(1)
local lastX = 0
local lastY = 0
local vx = 0
local vy = 0
local vw = 0
local vh = 0
local zoomX = false
local zoomY = false

_M.move = function(v,e)

  curr = v.Tag
  currView = v

  ry = e.getRawY()
  rx = e.getRawX()

  if e.getAction() == MotionEvent.ACTION_DOWN

    lp = v.getLayoutParams()
    vy = v.getY()
    vx = v.getX()
    lastY = ry
    lastX = rx
    vw = v.getWidth()
    vh = v.getHeight()

    if vw-e.getX() < 20

      zoomX = true

     elseif vh-e.getY() < 20

      zoomY = true

    end

   elseif e.getAction() == MotionEvent.ACTION_MOVE

    if zoomX

      lp.width = (vw+(rx-lastX))

     elseif zoomY

      lp.height = (vh+(ry-lastY))

     else

      lp.x = (vx+(rx-lastX))
      lp.y = (vy+(ry-lastY))

    end

    v.setLayoutParams(lp)

   elseif e.getAction() == MotionEvent.ACTION_UP

    if (rx-lastX)^2<100 and (ry-lastY)^2<100

      method.getCurr(v)

     else

      curr.layout_x = to(v.getX())
      curr.layout_y = to(v.getY())

      if zoomX

        curr.layout_width = to(v.getWidth())

       elseif zoomY

        curr.layout_height = to(v.getHeight())

      end
    end

    zoomX = false
    zoomY = false

  end

  return true

end

return _M