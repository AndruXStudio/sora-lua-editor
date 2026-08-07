local SimpleClass = lambda (t): setmetatable({}, { -- 不建议学（
  __call = function(self, ...)
    local object = setmetatable({}, {
      __index = function(self, key)
        local member = t[key]
        return type(member) == "function"
        and (lambda (...) : member(self, ...))
        or member
      end
    })
    t.new(object, ...)
    return object
  end
}) -- 表里的 new 作为构造器，其他的为动态成员

local bindClass = luajava.bindClass
local newInstance = luajava.newInstance
local android_R = bindClass "android.R"
local checkContext = lambda (c): assert(c, "The context of params could not be empty.")

local AlertDialog = bindClass "android.app.AlertDialog"

local showSthWithDialog = function(context, dialogTitle, sth)
  return AlertDialog.Builder(context)
  .setTitle(dialogTitle)
  .setItems(sth, {
    onClick = function(dialog, pos)
      local details = AlertDialog.Builder(context)
      .setMessage(sth[pos + 1])
      .show()
      .findViewById(android_R.id.message)
      .setTextIsSelectable(true)
    end
  })
  .setPositiveButton(android_R.string.ok, nil)
  .setNegativeButton(android_R.string.cancel, nil)
  .show()
end

local SpannableString = bindClass "android.text.SpannableString"
local Typeface = bindClass "android.graphics.Typeface"
local StyleSpan = bindClass "android.text.style.StyleSpan"
local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
local Spanned = bindClass "android.text.Spanned"

local PRINTS_ID = 0
local VARIABLES_ID = 1
local VARIABLE_TYPE_COLOUR = 0xff3D374E
local INFO_ICON_COLOUR = --[[ Red ]] 0xffAA3437
local ERROR_ICON_COLOUR = --[[ Green ]] 0xff006D3B

local Debugger = SimpleClass {
  --[[
  context : Activity
  windowService = WindowManagerImpl
  windowLayoutParams = WindowManager.LayoutParams
  imageView : ImageView
  popup : PopupMenu
  ]]
  ICON_MODE_INFO = 0,
  ICON_MODE_ERROR = 1,
  prints = {},

  new = function(self, context)
    checkContext(context)
    self.context = context

    local Context = bindClass "android.content.Context"
    local WindowManager = bindClass "android.view.WindowManager"
    local PixelFormat = bindClass "android.graphics.PixelFormat"
    local Gravity = bindClass "android.view.Gravity"

    self.windowService = context.getSystemService(
    Context.WINDOW_SERVICE)

    self.windowLayoutParams = WindowManager.LayoutParams() {
      format = PixelFormat.RGBA_8888,
      flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
      gravity = Gravity.LEFT | Gravity.TOP,
      x = context.getWidth() / 1.4,
      y = context.getHeight() / 5,
      width = -2, -- WRAP_CONTENT
      height = -2 -- WRAP_CONTENT
    }

    local tostring = tostring
    local select = select

    print = function(...)
      local n = select("#", ...)
      local buf = ""
      for i = 1, n do
        buf = buf .. tostring(select(i, ...))
        if i < n
          buf = buf .. "    "
        end
      end
      context.sendMsg(buf)
      self.addPrint(buf)
    end

    local MyOnError = function(err, content)
      if content then
        self.addPrint(err .. "\t\t" .. tostring(content))
       else
        self.addPrint(err)
      end
      self.setIconMode(self.ICON_MODE_ERROR)
    end

    local old_onError = onError
    onError = old_onError and function(...)
      MyOnError(...)
      old_onError()
    end or MyOnError

    error = onError

  end,

  setIconMode = function(self, mode)
    local color, res

    if mode == self.ICON_MODE_ERROR then
      color = INFO_ICON_COLOUR
      res = android_R.drawable.ic_dialog_alert
     elseif mode == self.ICON_MODE_INFO
      color = ERROR_ICON_COLOUR
      res = android_R.drawable.ic_dialog_info
     else
      error("The icon mode is not exist")
    end

    self.imageView {
      imageResource = res,
      colorFilter = color
    }
  end,

  showFloatWindow = function(self)
    local imageView = newInstance(
    "android.widget.ImageView",
    self.context)

    self.windowService.addView(imageView,
    self.windowLayoutParams)
    self.imageView = imageView
    self.setIconMode(self.ICON_MODE_INFO)

    local startX, startY, wmX, wmY
    imageView.setOnTouchListener {
      onTouch = function(v, event)
        if event.getAction() == 0
          startX = event.getRawX()
          startY = event.getRawY()
          wmX = self.windowLayoutParams.x
          wmY = self.windowLayoutParams.y
         elseif event.getAction() == 2
          self.windowLayoutParams.x = wmX + (event.getRawX() - startX)
          self.windowLayoutParams.y = wmY + (event.getRawY() - startY)
          self.windowService.updateViewLayout(imageView, self.windowLayoutParams)
          return false
        end
      end
    }

    imageView.setOnClickListener {
      onClick = function(view)
        if self.popup then
          self.popup.show()
          return
        end

        local popup = newInstance("android.widget.PopupMenu",
        self.context, view)
        local menu = popup.getMenu() -- Menu
        local GROUP_ID = 0
        -- MenuItem
        menu.add(GROUP_ID, PRINTS_ID, 0, "Show prints")
        .onMenuItemClick = self.showPrints
        menu.add(GROUP_ID, VARIABLES_ID, 1, "Show variables")
        .onMenuItemClick = self.showVariables

        popup.show()

        self.popup = popup
      end,
      onLongClickUseDefaultHapticFeedback = function()
        return true
      end
    }

    return self
  end,

  showPrints = function(self)
    local context = self.context

    local dialog = showSthWithDialog( context,
    "Prints",
    self.prints )

    dialog.getButton(AlertDialog.BUTTON_POSITIVE) {
      text = "Clear",
      onClickListener = {
        onClick = function(v)
          self.prints = {}
          dialog.dismiss()
        end,
        onLongClickUseDefaultHapticFeedback = function()
          return true
        end
      }
    }

    dialog.getListView().setSelection(
    #self.prints )
  end,

  showVariables = function(self)
    local type, tostring, utf8_len = type, tostring, utf8.len
    local variables = {}

    for k,v in pairs(_ENV) do
      local _type = type(v)
      local _typeStartLength = 0
      local _typeEndLength = utf8_len(_type)

      local item = _type .. " " .. tostring(v)

      local spanned = Spanned.SPAN_EXCLUSIVE_EXCLUSIVE

      local spannable = SpannableString(item)
      spannable.setSpan(
      ForegroundColorSpan(VARIABLE_TYPE_COLOUR),
      _typeStartLength, _typeEndLength,
      spanned)
      spannable.setSpan(
      StyleSpan(Typeface.BOLD),
      _typeStartLength, _typeEndLength,
      spanned)

      variables[#variables + 1] = spannable
    end

    showSthWithDialog(
    self.context,
    "Variables",
    variables )
  end,

  readLog = function(self, s)
    local p = io.popen("logcat -d -v long " .. s)
    s = p:read("*a")
    p:close()
    s = s:gsub("%-+ beginning of[^\n]*\n","")
    if #s == 0 then
      s = "<run the app to see its log output>"
    end
    return s
  end,

  addPrint = function(self, s)
    self.prints[#self.prints + 1] = s
  end
}

return Debugger