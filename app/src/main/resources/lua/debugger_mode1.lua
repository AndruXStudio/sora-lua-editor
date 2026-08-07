pcall(function()
  local File = luajava.bindClass "java.io.File"
  if File(activity.getLuaDir("config.json")).isFile()
    app = dofile(activity.getLuaDir("config.json"))
   else
    app = {}
    loadfile(activity.getLuaDir("init.lua"), "bt", app)
  end
  if app.debugmode == true then
 
    local bindClass = luajava.bindClass
    local newInstance = luajava.newInstance

    local _print = print
    local isOpenPanel = false

    --导入类
    local R = bindClass "com.load.LuaAppX.R"
    local MDC_R = bindClass "com.google.android.material.R"
    local InputMethodManager = bindClass "android.view.inputmethod.InputMethodManager"
    local System = bindClass "java.lang.System"
    local SimpleDateFormat = bindClass "android.icu.text.SimpleDateFormat"
    local ListView = bindClass "android.widget.ListView"
    local LuaAdapter = bindClass "com.androlua.LuaAdapter"
    local TypedValue = bindClass "android.util.TypedValue"
    local View = bindClass "android.view.View"
    local Build = bindClass "android.os.Build"
    local Context = bindClass "android.content.Context"
    local Gravity = bindClass "android.view.Gravity"
    local WindowManager = bindClass "android.view.WindowManager"
    local PixelFormat = bindClass "android.graphics.PixelFormat"
    local MotionEvent = bindClass "android.view.MotionEvent"
    local Toast = bindClass "android.widget.Toast"
    local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
    local ViewPager = bindClass "androidx.viewpager.widget.ViewPager"
    local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
    local MaterialTextView = bindClass "com.google.android.material.textview.MaterialTextView"
    local TextInputEditText = bindClass "com.google.android.material.textfield.TextInputEditText"
    local MaterialButton = bindClass "com.google.android.material.button.MaterialButton"
    local TabLayout = bindClass "com.google.android.material.tabs.TabLayout"
    local Typeface = bindClass "android.graphics.Typeface"
    local SpannableStringBuilder = bindClass "android.text.SpannableStringBuilder"
    local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
    local SpannableString = bindClass "android.text.SpannableString"
    local Spannable = bindClass "android.text.Spannable"
    local TypefaceSpan = bindClass "android.text.style.TypefaceSpan"
    local LuaThemeUtil = newInstance("github.daisukiKaffuChino.utils.LuaThemeUtil",activity)

    --引入波纹
    local circleRippleRes = TypedValue()
    activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackgroundBorderless, circleRippleRes, true)

    --引入颜色
    local colorPrimary = LuaThemeUtil.colorPrimary
    local colorBackground = LuaThemeUtil.colorBackground
    local colorPrimaryInverse = colorBackground
    local colorSurfaceVariant = LuaThemeUtil.colorSurfaceVariant
    local colorSurfaceContainer = LuaThemeUtil.colorSurfaceContainer
    local colorOnSurfaceVariant = LuaThemeUtil.colorOnSurfaceVariant

    --引入字体
    local Product = Typeface.createFromFile(activity.getDataDir().toString().."/files/res/font/Google_Sans_Mono_Regular.ttf")

    local idss = {}

    --悬浮球
    local vmWindow = {
      MaterialCardView,
      CardElevation="4dp",
      CardBackgroundColor=colorPrimary,
      id="vmLinearLayout1",
      {
        MaterialTextView,
        text="aConsole",
        textColor=colorBackground,
        layout_marginTop="7dp",
        layout_marginBottom="7dp",
        layout_margin="17dp",
        textSize="13dp",
        id="title",
        Typeface=Product,
      },
    }

    --悬浮窗口
    local variablesParams_x = activity.getWidth() / 1.4
    local variablesParams_y = activity.getHeight() / 5
    local variablesManager = activity.getSystemService(Context.WINDOW_SERVICE)
    local variablesParams = WindowManager.LayoutParams()
    local vmWindowALY = loadlayout(vmWindow,idss)
    variablesParams.format = PixelFormat.RGBA_8888
    variablesParams.flags = WindowManager.LayoutParams().FLAG_NOT_FOCUSABLE
    variablesParams.gravity = Gravity.LEFT | Gravity.TOP
    variablesParams.x = variablesParams_x
    variablesParams.y = variablesParams_y
    variablesParams.width = WindowManager.LayoutParams.WRAP_CONTENT
    variablesParams.height = WindowManager.LayoutParams.WRAP_CONTENT

    if ({
        pcall(function()
          variablesManager.addView(vmWindowALY, variablesParams)
        end
        )
      })[1] == false then
      Toast.makeText(activity,"调试面板启动失败",Toast.LENGTH_SHORT).show()
     else

      --读取日志
      local function readlog(s)
        local p = io.popen("logcat -d -v long "..s)
        local s = p:read("*a")
        p:close()
        s = s:gsub("%-+ beginning of[^\n]*\n","")
        if #s==0 then
          s = "<run the app to see its log output>"
        end
        return s
      end

      --清除日志
      local function clearlog()
        local p = io.popen("logcat -c")
        local s = p:read("*a")
        p:close()
        return s
      end

      task(clearlog)

      --检查日志
      local function tasklog(s)
        _print((s:gsub('^%[.+%]\n','')))
        safe_error((s:gsub('^%[.+%]\n','')))
        idss.title.setText("Run Error")
        idss.vmLinearLayout1.setCardBackgroundColor(0xFFE90000)
      end

      thread(function(activity)
        local Thread = luajava.bindClass "java.lang.Thread"
        local function readlog(s)
          local p=io.popen("logcat -d -v long "..s)
          local s=p:read("*a")
          p:close()
          s=s:gsub("%-+ beginning of[^\n]*\n","")
          if #s==0 then
            s="<run the app to see its log output>"
          end
          return s
        end
        while(true)
          local s=readlog('lua:* *:S')
          if s:find('Runtime%s-error') or s:find('错误')
            call('tasklog',s)
            break
          end
          if activity.isFinishing() or activity.isDestroyed()
            break
          end
          Thread.sleep(1000)
        end
      end,activity)


      --设置字体
      local function TypefaceString(str)
        local string = SpannableString(str)
        string.setSpan(TypefaceSpan(Product), 0, #string,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
        return string
      end
      
      local ids = {}

      --控制面板
      local vmWindow_2 = {
        LinearLayoutCompat,
        layout_width="fill",
        layout_height="fill",
        orientation="vertical",
        id="vmLinearLayout2",
        gravity="bottom",
        backgroundColor="0x80000000",
        {
          LinearLayoutCompat,
          orientation="vertical",
          backgroundColor=colorBackground,
          layout_width="fill",
          layout_height="80%h",
          onClick=function()
            return true
          end,
          {
            TabLayout,
            layout_width="fill",
            TabMode=2,
            id="mtab",
            backgroundColor=colorSurfaceContainer,
          },
          {
            View,
            layout_height="1dp",
            backgroundColor=colorSurfaceVariant,
          },
          {
            ViewPager,
            id="cvpgx",
            layout_weight=1,
            layout_width="fill",
            layout_height="fill",
            pagesWithTitle={
              {--View
                {
                  ListView,
                  layout_width="fill",
                  id="vmPrintListView",
                  fastScrollEnabled=true,
                  layout_height="fill"
                },
                {
                  LinearLayoutCompat,
                  orientation="vertical",
                  layout_width="fill",
                  layout_height="fill",
                  {
                    LinearLayoutCompat,
                    orientation="vertical",
                    layout_width="fill",
                    {
                      LinearLayoutCompat,
                      focusable=true,
                      layout_width="fill",
                      focusableInTouchMode=true,
                      {
                        MaterialTextView,
                        padding="5dp",
                        paddingRight="0",
                        textColor=colorOnSurfaceVariant,
                        textSize="13dp",
                        Typeface=Product,
                        text="当前节点: /",
                        id="vmVariableListView_path",
                        paddingLeft="6dp",
                      },
                      {
                        TextInputEditText,
                        padding="5dp",
                        paddingLeft="0",
                        textColor=colorOnSurfaceVariant,
                        textSize="13dp",
                        Typeface=Product,
                        backgroundColor="0",
                        singleLine="true",
                        paddingRight="6dp",
                        id="vmVariableListView_search",
                        layout_width="fill",
                        imeOptions="actionSearch",
                      },
                    },
                    {
                      View,
                      backgroundColor=colorSurfaceVariant,
                      layout_height="1dp",
                    },
                  },
                  {
                    ListView,
                    fastScrollEnabled=true,
                    id="vmVariableListView",
                    layout_width="fill",
                    layout_height="fill",
                  },
                },
                {
                  LinearLayoutCompat,
                  orientation="vertical",
                  layout_width="fill",
                  layout_height="fill",
                  {
                    LinearLayoutCompat,
                    layout_height="40dp",
                    id="logcat_bar",
                    gravity="center",
                    layout_width="fill",
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="A",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                    {
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="L",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                    {
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="T",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                    {
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="E",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                    {
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="W",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                    {
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="I",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                    {
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="D",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                    {
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      MaterialTextView,
                      Typeface=Product,
                      textSize="13dp",
                      text="V",
                      layout_width="12.5%w",
                      gravity="center",
                      layout_weight="1",
                    },
                  },
                  {
                    View,
                    layout_height="1dp",
                    backgroundColor=colorSurfaceVariant,
                  },
                  {
                    ListView,
                    overScrollMode="2",
                    fastScrollEnabled=true,
                    layout_width="fill",
                    id="vmLogcatListView",
                    layout_height="fill",
                  },
                },
                {
                  TextInputEditText,
                  background="0",
                  textSize="13sp",
                  layout_width="fill",
                  hint="Text...",
                  gravity="top",
                  Typeface=Product,
                  padding="8dp",
                  textColor=colorOnSurfaceVariant,
                  id="vmText"
                },
                {
                  LinearLayoutCompat,
                  orientation="vertical",
                  layout_width="fill",
                  {
                    MaterialTextView,
                    text="内存占用: ",
                    layout_width="fill",
                    textColor=colorPrimary,
                    textSize="13sp",
                    layout_margin="16dp",
                    layout_marginBottom="0dp",
                    Typeface=Product,
                    gravity="left|center",
                    id="vmMemory",
                  },
                  {
                    LinearLayoutCompat,
                    layout_width="fill",
                    layout_margin="16dp",
                    layout_marginBottom="0dp",
                    {
                      MaterialCardView,
                      id="control_btn1",
                      layout_weight="1",
                      layout_marginRight="8dp",
                      radius="0dp",
                      backgroundColor=colorPrimaryInverse,
                      {
                        MaterialTextView,
                        Typeface=Product,
                        text="关闭当前界面",
                        textSize="13dp",
                        padding="12dp",
                        gravity="center",
                        layout_width="fill",
                        layout_height="fill",
                      },
                    },
                    {
                      MaterialCardView,
                      id="control_btn2",
                      layout_weight="1",
                      layout_marginLeft="8dp",
                      radius="0dp",
                      backgroundColor=colorPrimaryInverse,
                      {
                        MaterialTextView,
                        Typeface=Product,
                        text="重构当前界面",
                        textSize="13dp",
                        padding="12dp",
                        gravity="center",
                        layout_width="fill",
                        layout_height="fill",
                      },
                    },
                  },
                  {
                    LinearLayoutCompat,
                    layout_width="fill",
                    layout_margin="16dp",
                    {
                      MaterialCardView,
                      id="control_btn3",
                      layout_weight="1",
                      layout_marginRight="8dp",
                      radius="0dp",
                      backgroundColor=colorPrimaryInverse,
                      {
                        MaterialTextView,
                        Typeface=Product,
                        textSize="13dp",
                        text="重启当前界面",
                        padding="12dp",
                        gravity="center",
                        layout_width="fill",
                        layout_height="fill",
                      },
                    },
                    {
                      MaterialCardView,
                      id="control_btn4",
                      layout_weight="1",
                      layout_marginLeft="8dp",
                      radius="0dp",
                      backgroundColor=colorPrimaryInverse,
                      {
                        MaterialTextView,
                        Typeface=Product,
                        textSize="13dp",
                        padding="12dp",
                        text="结束当前进程",
                        gravity="center",
                        layout_width="fill",
                        layout_height="fill",
                      },
                    },
                  },
                  {
                    LinearLayoutCompat,
                    orientation="vertical",
                    layout_height="fill",
                    layout_width="fill",
                    gravity="bottom",
                    {
                      View,
                      layout_height="1dp",
                      backgroundColor=colorSurfaceVariant,
                    },
                    {
                      LinearLayoutCompat,
                      layout_width="fill",
                      orientation="horizontal",
                      {
                        TextInputEditText,
                        background="0",
                        textSize="13sp",
                        layout_width="fill",
                        hint="Lua Code...",
                        textColor=colorOnSurfaceVariant,
                        layout_weight=1,
                        Typeface=Product,
                        id="vmLuaCode",
                        padding="14dp",
                      },
                      {
                        LinearLayoutCompat,
                        orientation="vertical",
                        layout_height="fill",
                        {
                          MaterialCardView,
                          radius="0dp",
                          StrokeWidth="0dp",
                          backgroundColor=colorSurfaceVariant,
                          layout_height="fill",
                          layout_width="fill",
                          id="control_run",
                          {
                            MaterialTextView,
                            text="Run",
                            gravity="center",
                            layout_height="fill",
                            layout_width="fill",
                            textSize="13sp",
                            Typeface=Product,
                            paddingLeft="20dp",
                            paddingRight="20dp",
                            textColor=colorOnSurfaceVariant
                          },
                        },
                      },
                    },
                  },
                },
              },
              {--Title
                TypefaceString("Prints"),
                TypefaceString("Variables"),
                TypefaceString("Logcat"),
                TypefaceString("Text"),
                TypefaceString("Other")
              },
            },
          },
          {
            MaterialCardView,
            layout_width="fill",
            radius="0dp",
            backgroundColor=colorSurfaceContainer,
            StrokeWidth="0dp",
            {
              View,
              layout_height="1dp",
              backgroundColor=colorSurfaceVariant,
            },
            {
              LinearLayoutCompat,
              id="bar",
              layout_height="45dp",
              layout_width="fill",
            },
          },
        },
      }
      local vmWindowALY_2 = loadlayout(vmWindow_2,ids)

      ids.mtab.setupWithViewPager(ids.cvpgx)

      function idss.vmLinearLayout1.OnTouchListener(v, event)
        if event.getAction() == 0
          variablesParams_firstX = event.getRawX()
          variablesParams_firstY = event.getRawY()
          variablesParams_wmX = variablesParams.x
          variablesParams_wmY = variablesParams.y
         elseif event.getAction() == 2
          variablesParams_x = variablesParams_wmX + (event.getRawX() - variablesParams_firstX)
          variablesParams_y = variablesParams_wmY + (event.getRawY() - variablesParams_firstY)
          variablesParams.x = variablesParams_x
          variablesParams.y = variablesParams_y
          variablesManager.updateViewLayout(vmWindowALY, variablesParams)
          return false
        end
      end

      --关闭调试面板
      local function changeVMWindow()
        if isOpenPanel == false
          isOpenPanel = true
          variablesManager.removeView(vmWindowALY)
          variablesParams.flags = WindowManager.LayoutParams().FLAG_LAYOUT_IN_SCREEN | WindowManager.LayoutParams().FLAG_NOT_TOUCH_MODAL
          variablesParams.x = activity.getWidth()
          variablesParams.y = activity.getHeight()
          variablesParams.width = WindowManager.LayoutParams.MATCH_PARENT
          variablesParams.height = WindowManager.LayoutParams.MATCH_PARENT
          variablesManager.addView(vmWindowALY_2, variablesParams)
         else
          isOpenPanel = false
          variablesManager.removeView(vmWindowALY_2)
          variablesParams.flags = WindowManager.LayoutParams().FLAG_NOT_FOCUSABLE
          variablesParams.x = variablesParams_x
          variablesParams.y = variablesParams_y
          variablesParams.width = WindowManager.LayoutParams.WRAP_CONTENT
          variablesParams.height = WindowManager.LayoutParams.WRAP_CONTENT
          variablesManager.addView(vmWindowALY, variablesParams)
        end
      end

      function idss.vmLinearLayout1.onClick()
        changeVMWindow()
        return true
      end

      function ids.vmLinearLayout2.onClick()
        changeVMWindow()
        return true
      end

      local vmItem = {
        LinearLayoutCompat,
        orientation="vertical",
        layout_width="fill",
        {
          MaterialTextView,
          id="text",
          gravity="center|left",
          textSize="13sp",
          layout_width="fill",
          MaxLines=5,
          Typeface=Product,
          layout_margin="8dp",
          ellipsize="end"
        },
      }

      local vmPrintListView_data = {}
      vmPrintListView_adp = LuaAdapter(activity, vmPrintListView_data, vmItem)
      ids.vmPrintListView.setAdapter(vmPrintListView_adp)

      --print

      --添加打印日志
      local function log(color, iss, ...)

        local str = {}
        local arg = {...}
        local date = SimpleDateFormat("HH:mm:ss.SSS:  ")

        for k,v ipairs(arg)
          str[#str+1]=tostring(v)
          if k!=#arg
            str[#str+1]='   '
          end
        end

        local s=table.concat(str)

        if iss
          s = date.format(System.currentTimeMillis()) .. s
        end

        table.insert(vmPrintListView_data, {
          text = {
            Text = s,
            textColor = color
          }
        })

        return ...
      end

      --打印默认日志
      local function vmPrintListView_default()
        local pkg = this.getPackageManager().getPackageInfo(this.getPackageName(),0)
        log(colorPrimary,nil,
        string.format('System: %s, Android %s (SDK%s), %s - %s',
        Build.MODEL,Build.VERSION.RELEASE,Build.VERSION.SDK,pkg.applicationInfo.loadLabel(this.getPackageManager())
        ,pkg.versionName))
        log(colorPrimary,nil,'File: '..this.getLuaPath())
      end

      function print(...)
        return log(colorOnSurfaceVariant,1,...)
      end

      function safe_error(...)
        return log(0xFFE90000,1,...)
      end

      function explain(...)
        return log(0xFF808080,1,...)
      end

      function info(...)
        return log(0xFF00A000,1,...)
      end

      function warning(...)
        return log(0xFFE97E00,1,...)
      end

      local _err = error
      function error(a,b)
        _print(a)
        _err(log(0xFFE90000,1,a),b)
      end

      local _ass = assert
      function assert(a,...)
        if !a
          _print(...)
          log(0xFFE90000,1,...)
        end
        return _ass(a,...)
      end

      local MyOnError = function(err, content)
        if content then
          safe_error(err .. ":\n" .. tostring(content))
         else
          safe_error(err)
        end
        idss.title.setText("Run Error")
        idss.vmLinearLayout1.setCardBackgroundColor(0xFFE90000)
      end

      local old_onError = onError
      onError = old_onError and function(...)
        MyOnError(...)
        old_onError()
      end or MyOnError

      function ids.vmPrintListView.onItemClick(parent, view, position, id)
        ids.vmText.setText(tostring(view.Tag.text.Text))
        ids.cvpgx.setCurrentItem(3)
        return true
      end

      --variable

      local variable_path = {}
      local flags = Spannable.SPAN_INCLUSIVE_INCLUSIVE
      local variable_kv = {}
      local variable_span = {}
      local variable_node = {}
      local variable_data = {}
      local variable_adp = LuaAdapter(activity, variable_data,
      {
        MaterialTextView,
        layout_width="fill",
        textSize="13dp",
        padding="5dp",
        paddingLeft="6dp",
        paddingRight="16dp",
        singleLine="true",
        ellipsize="end",
        Typeface=Product,
        id="kv",
      })

      ids.vmVariableListView.setAdapter(variable_adp)

      local function add(tab, str)
        variable_data[#variable_data + 1] = {
          kv = {
            text = str,
            textColor = 0xff808080
          }
        }
        variable_kv[#variable_data] = tab
      end

      local color_span1 = ForegroundColorSpan(0xFF00a000)
      local color_span2 = ForegroundColorSpan(colorPrimary)
      local color_span3 = ForegroundColorSpan(0xFF7F00FF)
      local color_span4 = ForegroundColorSpan(0xFF00A000)
      local color_span5 = ForegroundColorSpan(0xFFE97E00)

      --开始添加variable
      local function tree()
        local tab = _ENV

        table.clear(variable_path)
        table.clear(variable_data)

        for k, v in ipairs(variable_node) do
          if type(tab[v]) == 'table' then
            tab = tab[v]
           else
            variable_node[k] = nil
          end
        end

        local t = {}
        for k, v in ipairs(variable_node) do
          t[k] = tostring(v)
        end

        local s = table.concat(t, '/')

        if #s > 0 then
          s = s .. "/"
        end

        ids.vmVariableListView_path.setText("当前节点: /" .. s)

        table.clear(variable_data)
        if #variable_node ~= 0 then
          add(1, "返回父节点")
        end

        add(2, "序列化节点")

        for k, v in pairs(tab) do
          local _k, _v = k, v

          v = tostring(v)
          if v then
            if utf8.len(v) > 80 then
              v = utf8.sub(v, 1, 80) .. '...'
            end

            if type(k) ~= 'string' then
              k = string.format('[%s]', tostring(k))
            end

            if type(_v) == 'string' then
              v = string.format('"%s"', v)
             elseif type(_v) == 'table' then
              v = string.format('%s => {...}', v)
            end

            local s = string.format('%s => %s', k, tostring(v))

            local span
            if variable_span[#variable_data+1] then
              span = variable_span[#variable_data+1]
             else
              span = SpannableStringBuilder()
            end

            span.clearSpans()
            span.clear()
            span.append(s)

            local s1, e1 = utf8.find(s, '=>')

            span.setSpan(color_span2, 0, utf8.len(k), flags)
            span.setSpan(color_span1, s1-1, e1, flags)

            if type(_v) == 'table' then
              if s:find('table') then
                local s0, e0 = utf8.find(s, 'table:%s-0x%x+%s')
                span.setSpan(color_span3, s0-1, e0, flags)
                local s1, e1 = utf8.find(s, '=>', e0)
                span.setSpan(color_span4, s1-1, e1, flags)
                local s2, e2 = utf8.find(s, '{%.%.%.}', e1)
                span.setSpan(color_span5, s2-1, e2, flags)
                variable_path[tostring(_k)] = _k
              end
            end
            add({_k, _v}, span)
          end
        end

        variable_adp.notifyDataSetChanged()
        ids.vmVariableListView.setStackFromBottom(true)
        ids.vmVariableListView.setStackFromBottom(false)
      end

      --列表点击
      ids.vmVariableListView.onItemClick = function(a, b, c, d)
        local t = variable_kv[d]
        if t == 1 then
          variable_node[#variable_node] = nil
          tree()
         elseif t == 2 then
          local tab = _ENV
          for k, v in ipairs(variable_node) do
            tab = tab[v]
          end
          ids.vmText.setText(dump(tab))
          ids.cvpgx.setCurrentItem(3, false)
         else
          if type(t[2]) == "table" then
            variable_node[#variable_node+1] = t[1]
            tree()
           else
            ids.vmText.setText(tostring(t[2]))
            ids.cvpgx.setCurrentItem(3, false)
          end
        end
      end

      --列表长按
      ids.vmVariableListView.onItemLongClick = function(a, b, c, d)
        ids.vmText.setText(string.format('%s/%s', table.concat(variable_node, '/'), b.text:match('(.+)%s=>')))
        ids.cvpgx.setCurrentItem(3,false)
        return true
      end

      --回车搜索
      ids.vmVariableListView_search.onEditorAction = function(v, actionId, event)
        if actionId == 0 then
          local target_node = variable_path[v.text]
          if target_node then
            variable_node[#variable_node+1] = target_node
            v.setText('')
            tree()
          end
        end
        return false
      end

      --logcat
      local logcat_pos,show=1

      local items={"All","Lua","Tcc","Error","Warning","Info","Debug","Verbose"}
      local types={'',"lua:* *:S","tcc:* *:S","*:E","*:W","*:I","*:D","*:V"}

      local logcat_text={}
      local logcat_data={}
      local logcat_adp=LuaAdapter(activity,logcat_data,{
        MaterialTextView,
        layout_width="fill",
        textSize="13dp",
        padding="5dp",
        paddingLeft="6dp",
        paddingRight="16dp",
        Typeface=Product,
        textColor=colorPrimary,
        id='txt',
      })

      ids.vmLogcatListView.setAdapter(logcat_adp)

      ids.vmLogcatListView.onItemClick=function(a,b,c,d)
        ids.vmText.setText(logcat_text[d])
        ids.cvpgx.setCurrentItem(3,false)
      end

      local function read()
        task(readlog,types[logcat_pos],function(str)
          table.clear(logcat_data)
          local t,n={},0
          str:gsub('[^\n\n]+',function(w)
            if n%2==0
              if !w:find('^%[')
                t[#t]=string.format('%s\n%s',t[#t],w)
               else
                t[#t+1]=w
                n=n+1
              end
             else
              t[#t]=string.format('%s\n%s',t[#t],w)
              n=n+1
            end
          end)
          for k,v ipairs(t)
            logcat_data[k]={
              txt={
                text=v,
              }
            }
            logcat_text[k]=v
          end
          logcat_adp.notifyDataSetChanged()
        end)
      end

      for i=0,7
        local v=ids.logcat_bar.getChildAt(i*2)
        .setTextColor(0xFF909090)
        v.onClick=function(v0)
          logcat_pos = i+1
          for i=0,14,2
            local _v = ids.logcat_bar.getChildAt(i)
            .setTextColor(0xFF909090)
          end
          v0.setTextColor(colorPrimary)
          read()
        end
      end

      local v = ids.logcat_bar.getChildAt(0)
      .setTextColor(colorPrimary)

      --other
      ids.control_btn1.onClick=function()
        activity.finish()
      end

      ids.control_btn2.onClick=function()
        activity.recreate()
      end

      ids.control_btn3.onClick=function()
        activity.finish()
        this.startActivity(this.getIntent())
      end

      ids.control_btn4.onClick=function()
        os.exit()
      end

      ids.control_run.onClick=function()
        local f,e=load(ids.vmLuaCode.text)
        if f
          local v,e=pcall(f)
          if v
            ids.vmLuaCode.setText(nil)
           else
            safe_error(e)
            ids.vmLuaCode.setError("程序出错")
          end
         else
          safe_error(e)
          ids.vmLuaCode.setError("语法错误")
        end
        return true
      end

      --bar
      local btn_list={
        {
          'Clear',function(v)
            vmPrintListView_adp.clear()
            vmPrintListView_default()
          end,
          'Hide',function(v)
            changeVMWindow()
          end
        },
        {
          'Refresh',function(v)
            tree()
          end,
          'Hide',function(v)
            changeVMWindow()
          end
        },
        {
          'Clear',function(v)
            task(clearlog,read)
          end,
          'Hide',function(v)
            changeVMWindow()
          end
        },
        {
          'Copy',function(v)
            activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(ids.vmText.Text)
            Toast.makeText(activity, "复制成功",Toast.LENGTH_SHORT).show()
          end,
          'Paste',function(v)
            ids.vmText.setText(activity.getSystemService(Context.CLIPBOARD_SERVICE).getText())
          end,
          'Clear',function(v)
            ids.vmText.setText(nil)
          end,
          'Hide',function(v)
            changeVMWindow()
          end
        },
        {
          'Hide',function(v)
            changeVMWindow()
          end
        }
      }

      local btn_cache={}

      local p=-1
      ids.cvpgx.addOnPageChangeListener{
        onPageScrolled=function(pos)
          if pos != p
            p = pos
            if pos == 1
              tree()
             elseif pos == 2
              read()
             elseif pos == 4
              ids.vmMemory.setText("内存占用: " .. tostring(string.format("%0.2f", collectgarbage("count"))) .. " KB")
            end

            ids.bar.removeAllViews()

            task(100,function()
              ids.bar.post(function()
                local tab = btn_list[pos+1]
                local n = 0
                local width = ids.bar.getWidth()/(#tab/2)
                ids.bar.removeAllViews()
                for i=1,#tab,2
                  n = n+1
                  local lay
                  if btn_cache[n]
                    lay = btn_cache[n]
                   else
                    lay = loadlayout({
                      MaterialTextView,
                      layout_height="fill",
                      textSize="13dp",
                      text=tab[i],
                      gravity="center",
                      backgroundResource=circleRippleRes.resourceId,
                      textColor=colorOnSurfaceVariant,
                      Typeface=Product,
                    })
                    btn_cache[n] = lay
                  end
                  lay.setWidth(width)
                  lay.setText(tab[i])
                  lay.onClick = tab[i+1]
                  ids.bar.addView(lay)
                  if n!=#tab/2
                    ids.bar.addView(loadlayout({
                      View,
                      layout_width="1dp",
                      backgroundColor=colorSurfaceVariant,
                    }))
                  end
                end
              end)
            end)
          end
        end
      }

      vmPrintListView_default()

    end

  end
end)