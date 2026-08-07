require "environment"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local PopupRecyclerAdapter = bindClass "github.znzsofficial.adapter.PopupRecyclerAdapter"
local path = ...
local SelectedState = {}

this {
  Title = res.string.analysis_import,
  ContentView = res.view.fix_layout,
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

      return utf8.sub(data[position+1],1 ,1)

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

      views.message.setVisibility(8)

      views.license.setVisibility(8)

      views.name.setText(currentData).setTextSize(TextSize)

      if select_all views.cardView.setStrokeColor(Colors.colorOutline) end

      views.cardView.setChecked(SelectedState[currentData] or false)

      views.cardView.onClick = function(v)

        v.setChecked(not v.isChecked())

      end

      views.cardView.setOnLongClickListener(this.onLongClickX(function()

        this.getSystemService("clipboard").setText("import " .. "\"" .. currentData .. "\"")

        MyToast(res.string.copied)

        return true

      end))

      views.cardView.setOnCheckedChangeListener{
        onCheckedChanged=function(v, isChecked)

          SelectedState[currentData] = isChecked

          if isChecked

            v.setStrokeColor(Colors.colorOutline)

           else

            v.setStrokeColor(Colors.colorSurfaceVariant)

          end

        end
      }

    end
  }))

  recyclerView
  .setAdapter(adapter)
  .setLayoutManager(LinearLayoutManager())

end

onOptionsItemSelected = function(v)

  if v.getItemId() == android.R.id.home

    finish()

  end

end

onCreateOptionsMenu = function(menu)

  menu.add(TypefaceString(res.string.select_all))
  .onMenuItemClick=function()

    if data

      for k, v ipairs(data)

        SelectedState[v] = true

      end

      select_all = true

      init()

    end

  end

  menu.add(TypefaceString(res.string.copy))
  .onMenuItemClick=function()

    if data

      local Select = {}

      for k,v pairs(SelectedState)

        if v

          table.insert(Select, string.format("import \"%s\"", k))

        end

      end

      local str = table.concat(Select, "\n")

      this.getSystemService("clipboard").setText(str)

      MyToast(res.string.copied)

    end

  end

end

fiximport = function(path)

  this.newTask(function(path)

    local bindClass = luajava.bindClass
    local String = bindClass "java.lang.String"
    local LuaLexer = bindClass "com.androlua.LuaLexer"
    local LuaTokenTypes = bindClass "com.androlua.LuaTokenTypes"

    local classes = require "activities.JavaApi.PublicClasses"
    local searchpath = path:gsub("[^/]+%.lua","?.lua;") .. path:gsub("[^/]+%.lua","?.aly;")
    local cache = {}

    checkclass = function(path,ret)

      if cache[path]
        return
      end

      cache[path] = true
      local f = io.open(path)
      local str = f:read("a")
      f:close()

      if not str
        return
      end

      for s,e,t in str:gfind("import \"([%w%.]+)\"")

        local p = package.searchpath(t, searchpath)

        if p

          checkclass(p,ret)

        end

      end

      local lex = LuaLexer(str)
      local buf = {}
      local last = nil

      while true

        local t = lex.advance()

        if not t

          break

        end

        if last ~= LuaTokenTypes.DOT and t == LuaTokenTypes.NAME

          local text=lex.yytext()

          buf[text]=true

        end

        last = t

      end

      table.sort(buf)

      for k,v pairs(buf)

        local k = "[%.$]" .. k .. "$"

        for key,value ipairs(classes)

          local z = tostring(string.match(value, "%w+$"))

          if string.find(value,k)

            if cache[value] == nil

              table.insert(ret,value)

              cache[value]=true

            end

          end

        end

      end

    end

    local ret = {}

    checkclass(path,ret)

    return ret

    end,function(ret)

    data = luajava.astable(ret)

    table.sort(data, function(a, b)

      return a < b

    end)

    init()

    progressView.setVisibility(8)
    recyclerView.setVisibility(0)

  end).execute({ path })

end

fiximport(path)