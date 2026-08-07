require "environment"
require "activities.Parsing.ParsingActivity$util"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local PopupRecyclerAdapter = bindClass "github.znzsofficial.adapter.PopupRecyclerAdapter"
local ActivityUtil = require "mods.utils.ActivityUtil"
local classz = ...
class = bindClass(classz)

this {
  Title = string.match(..., "%w+$"),
  ContentView = res.view.parsing_layout,
  SupportActionBar = toolbar,
}
.getSupportActionBar()
.setDisplayHomeAsUpEnabled(true)
.setSubtitle(classz)

onOptionsItemSelected = function(item)

  if item.getItemId() == android.R.id.home

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
      local currentData = tostring(data[position+1])

      views.name.setTextSize(TextSize)

      views.license.setVisibility(8)

      if tag == "aa"

        views.name.setText(currentData:match(" (.+)"))

        views.message.setText(currentData:match("(.+) "))

       elseif tag == "bb"

        views.name.setText(tostring(currentData:match(" (.-)%("):gsub(".+%.(%w+)", "%1") .. "(" .. Substitution(currentData) .. ")"))

        views.message.setText(currentData:match("(.+) "))

       elseif tag == "cc"

        views.name.setText((currentData:match("%s([^%s]+)$"):match("(.+)%(")):gsub(".+%.(%w+)", "%1") .. "(" .. Substitution(currentData) .. ")")

        views.message.setText(currentData:match("(.-)%s[^%s]+$"):match("%s([^%s]+)$"))

       elseif tag == "dd"

        views.message.setVisibility(8)

        views.name.setText(currentData)

       elseif tag == "ee"

        views.name.setText(currentData:match("%s([^%s]+)$"))

        views.message.setText(currentData:match("(.-)%s[^%s]+$"))

      end

      views.cardView.onClick = function()

        local text = views.name.getText()

        if tag == "aa"

          ActivityUtil.new("Parsing", { text })

        end

      end

      views.cardView.setOnLongClickListener(this.onLongClickX(function()

        this.getSystemService("clipboard").setText(views.name.getText())

        MyToast(res.string.copied)

        return true
      end))

    end
  }))

  recyclerView
  .setAdapter(adapter)
  .setLayoutManager(LinearLayoutManager())

end


local read = function(tag, text)

  local class = eee[tag]

  if not text text = "" end

  data = {}

  for k, v pairs(class)

    try

      if string.find(v, text)

        table.insert(data, v)

      end

    end

  end

  table.sort(data, function(a, b)

    return a > b

  end)

  init()

  progressView.setVisibility(8)

  recyclerView.setVisibility(0)

end


this.newTask(function(classz, aas)

  local eeee, classs = aas(classz)

  return eeee

  end,function(eeee)

  eee = eeee

  tag = "aa"

  read(tag, "")

end).execute({classz, aas})


local aaa = {
  "aa",
  "bb",
  "cc",
  "dd",
  "ee",
}

for index,content ipairs({
    res.string.parent_class,
    res.string.construct,
    res.string.method,
    res.string.event,
    res.string.field,
  })

  tab.addTab(tab.newTab().setText(setFontSize(TypefaceString(content),TextSize + 1)).setTag(aaa[index]))

end

tab.addOnTabSelectedListener(bindClass "com.google.android.material.tabs.TabLayout".OnTabSelectedListener{onTabSelected=onTabSelected,
  onTabSelected = function(v)

    tag = v.tag

    read(tag, "")

end})

name.addTextChangedListener{
  onTextChanged=function(text)

    read(tag, tostring(text))

  end
}