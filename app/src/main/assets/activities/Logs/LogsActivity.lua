require "environment"
local Spannable = bindClass "android.text.Spannable"
local TypefaceSpan = bindClass "android.text.style.TypefaceSpan"
local BackgroundColorSpan = bindClass "android.text.style.BackgroundColorSpan"
local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
local SpannableString = bindClass "android.text.SpannableString"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local PopupRecyclerAdapter = bindClass "github.znzsofficial.adapter.PopupRecyclerAdapter"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"

this {
  Title = res.string.logs,
  ContentView = res.view.logs_layout,
  SupportActionBar = toolbar
}
.getSupportActionBar()
{
  DisplayHomeAsUpEnabled = true
}

local init = function()

  newInstance("me.zhanghai.android.fastscroll.FastScrollerBuilder", recyclerView)
  .useMd2Style()
  .setPadding(0,dp2px(8),dp2px(2),dp2px(8))
  .build()

  adapter = PopupRecyclerAdapter(this, PopupRecyclerAdapter.PopupCreator({

    getItemCount = function()

      return #data

    end,

    getItemViewType = function()

      return 0

    end,

    getPopupText = function(view, position)

      return ""

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

      if currentData.type == 1

        views.message.setVisibility(8)

       else

        views.cardView.onClick = function()

          MaterialAlertDialog(this)
          .setTitle(currentData.title)
          .setMessage(currentData.content)
          .setPositiveButton(res.string.copy, function()

            this.getSystemService("clipboard").setText(currentData.content)

          end)
          .setNegativeButton(res.string.no)
          .show()

        end

        views.message.setVisibility(0)

        views.message.setText(currentData.content)

      end

      views.name.setText(currentData.title).setTextSize(TextSize)

    end
  }))

  recyclerView
  .setAdapter(adapter)
  .setLayoutManager(LinearLayoutManager())

end

local actionBar = this.getSupportActionBar()

local filterNames = {res.string.all, "Lua", "Test", "Tcc", "Error", "Warning", "Info", "Debug", "Verbose"}
local filterParameters = {"", "lua:* *:S", "test:* *:S", "tcc:* *:S", "*:E", "*:W", "*:I", "*:D", "*:V"}

local type2color = {
  V = 0xFF000000,
  D = 0xff2196f3,
  I = 0xff4caf50,
  W = 0xffff9800,
  E = 0xfff44336,
}

onCreateOptionsMenu = function(menu)

  refreshMenu = menu.add(res.string.refresh)

  clearMenu = menu.add(res.string.empty_all)

end

onOptionsItemSelected = function(item)

  local id = item.getItemId()

  local title = item.title

  if id == android.R.id.home

    finish()

   elseif item == refreshMenu

    readLog(filterParameters[index])

   elseif item == clearMenu

    task(clearLog,readLog)

  end
end

function show(content)

  progressView.setVisibility(8)
  recyclerView.setVisibility(0)

  data = {}

  if content and #content~=0

    local nowTitle = ""
    local nowTag = ""
    local nowContent = ""

    for line content:gmatch("(.-)\n")

      if line:find("^%-%-%-%-%-%-%-%-%- beginning of ")

        table.insert(data, { type = 1, title = line})

       elseif line:find("^%[ *%d+%-%d+ *%d+:%d+:%d+%.%d+ *%d+: *%d+ *%a/[^ ]+ *%]$")

        local date, time, processId, threadId, logType, logTag = line:match("^%[ *(%d+%-%d+) *(%d+:%d+:%d+%.%d+) *(%d+): *(%d+) *(%a)/([^ ]+) *%]$")

        title = "[ "..date.." "..time.." "..processId..":"..threadId.."  "

        local typeIndex = utf8.len(title)
        title = title..logType.." /"..logTag.." ]"
        title = SpannableString(title)
        title.setSpan(BackgroundColorSpan(type2color[logType] or 0),typeIndex-1,typeIndex+2,Spannable.SPAN_INCLUSIVE_INCLUSIVE)
        title.setSpan(ForegroundColorSpan(0xFFFFFFFF),typeIndex-1,typeIndex+2,Spannable.SPAN_INCLUSIVE_INCLUSIVE)
        title.setSpan(TypefaceSpan("monospace"),typeIndex-1,typeIndex+2,Spannable.SPAN_INCLUSIVE_INCLUSIVE)

        if nowContent ~= "" and nowTag ~= "LuaInvocationHandler"

          table.insert(data,{ type = 2, title = title, content = String(nowContent).trim()})

        end

        nowTitle = title
        nowTag = logTag
        nowContent = ""

       else

        nowContent = nowContent .. "\n" .. line

      end

    end

   else

    table.insert(data, { type = 1, title = "<" .. res.string.run_the_application_to_view_its_log_output .. ">"})

  end

end



readLog = function(value)

  progressView.setVisibility(0)
  recyclerView.setVisibility(8)

  this.newTask(function(value)

    local p=io.popen("logcat -d -v long " .. value)
    local content = p:read("*a")
    p:close()

    return content

    end,function(content)

    show(tostring(content))

    init()

  end).execute({value or ""})

end

clearLog = function()

  local p=io.popen("logcat -c")
  p:close()

end

for index,content ipairs(filterNames)

  tab.addTab(tab.newTab().setText(setFontSize(TypefaceString(content),TextSize + 1)).setTag(1))

end

readLog()

tab.addOnTabSelectedListener(bindClass "com.google.android.material.tabs.TabLayout".OnTabSelectedListener{onTabSelected=onTabSelected,
  onTabSelected = function()

    index = tab.getSelectedTabPosition() + 1

    readLog(filterParameters[index])

end})