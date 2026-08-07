require "environment"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local PopupRecyclerAdapter = bindClass "github.znzsofficial.adapter.PopupRecyclerAdapter"
local ActivityUtil = require "mods.utils.ActivityUtil"
local simpleList = ... or false

this {
  Title = res.string.api_title,
  ContentView = res.view.javaapi_layout,
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

      return utf8.sub(data[position + 1].content, 1 , 1)

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

      views.name.setText(currentData.title).setTextSize(TextSize)

      views.message.setText(currentData.content)

      views.cardView.onClick = function()

        ActivityUtil.new("Parsing", { tostring(currentData.content) })

      end

      views.cardView.setOnLongClickListener(this.onLongClickX(function()

        this.getSystemService("clipboard").setText(currentData.content)

        MyToast(res.string.copied)

        return true
      end))

    end
  }))

  recyclerView
  .setAdapter(adapter)
  .setLayoutManager(LinearLayoutManager())

end

local find = function(text)

  progressView.setVisibility(0)

  recyclerView.setVisibility(8)

  this.newTask(function(simpleList, text)

    if not text text = "" end

    local classes2 = {}

    if simpleList

      classes = require"activities.JavaApi.allClasses"

     else

      classes = require "activities.JavaApi.PublicClasses"

    end

    for k, v ipairs(classes)

      local title = string.match(v, "%w+$")

      if string.find(title, text) or string.find(v, text)

        table.insert(classes2, { title = title , content = v })

      end

    end

    return classes2

    end,function(classes2)

    data = luajava.astable(classes2)

    name_root.setHint(#data .. res.string.classes)

    table.sort(data, function(a, b)

      return a.content < b.content

    end)

    init()

    progressView.setVisibility(8)

    recyclerView.setVisibility(0)

  end).execute({ simpleList, text })

end

find()

name.addTextChangedListener{
  onTextChanged=function(text)

    find(tostring(text))

  end
}

fab.onClick =function()
  this.newActivity("activities/JavaApi/JavaApiActivity",{ not simpleList } )
  this.overridePendingTransition(android.R.anim.fade_in,android.R.anim.fade_out)
  finish()
end