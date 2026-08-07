local _M={}
local LuaCustRecyclerHolder = bindClass "com.lua.custrecycleradapter.LuaCustRecyclerHolder"
local LuaCustRecyclerAdapter = bindClass "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
local AdapterCreator = bindClass "com.lua.custrecycleradapter.AdapterCreator"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local MaterialSwitch = bindClass "com.google.android.material.materialswitch.MaterialSwitch"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local ColorStateList = bindClass "android.content.res.ColorStateList"
local View = bindClass "android.view.View"
local GlideUtil = require "mods.utils.GlideUtil"
local ColorUtil = require "mods.utils.ColorUtil"

_M.TITLE = 1
_M.ITEM = 2
_M.ITEM_NOSUMMARY = 3
_M.ITEM_SWITCH = 4
_M.ITEM_SWITCH_NOSUMMARY = 5
_M.ITEM_AVATAR = 6
_M.ITEM_ONLYSUMMARY = 7
_M.TIEM_CARD = 8
_M.TIME_NOICON = 9
_M.TIME_SWITCH_NOICON = 10

local leftIconLay = {
  AppCompatImageView,
  id="icon",
  colorFilter=Colors.colorPrimary,
  layout_margin="16dp",
  layout_marginLeft="20dp",
  layout_width="24dp",
  layout_height="24dp",
}

local leftCoverLay = {
  MaterialCardView,
  layout_height="40dp",
  layout_width="40dp",
  layout_margin="16dp",
  layout_marginLeft="20dp",
  layout_marginRight=0,
  radius="360dp",
  StrokeColor=Colors.colorSurfaceVariant,
  {
    AppCompatImageView,
    layout_height="fill",
    layout_width="fill",
    id="icon",
  },
}

local leftCoverIconLay = {
  MaterialCardView,
  layout_height="40dp",
  layout_width="40dp",
  layout_margin="16dp",
  layout_marginRight=0,
  layout_marginLeft="20dp",
  radius="360dp",
  StrokeColor=Colors.colorSurfaceVariant,
  {
    AppCompatImageView,
    layout_height="24dp",
    layout_width="24dp",
    layout_gravity="center",
    id="icon",
  },
}

local oneLineLay = {
  AppCompatTextView,
  id="title",
  textSize=TextSize + 2,
  Typeface=Typeface_TTF(),
  ellipsize="middle",
  MaxLines=1,
  textColor=Colors.colorOnBackground,
  layout_weight=1,
  layout_marginLeft="12dp",
  layout_marginRight="16dp",
}

local twoLineLay = {
  LinearLayoutCompat,
  orientation="vertical",
  gravity="center",
  layout_weight=1,
  layout_margin="12dp",
  {
    AppCompatTextView,
    id="title",
    Alpha=0.9,
    textSize=TextSize + 2,
    Typeface=Typeface_TTF(),
    layout_width="fill",
    layout_marginBottom="1dp",
    textColor=Colors.colorOnBackground,
  },
  {
    AppCompatTextView,
    textSize=TextSize,
    ellipsize="end",
    id="summary",
    Typeface=Typeface_TTF(),
    textColor=Colors.colorOutline,
    layout_marginTop="1dp",
    layout_width="fill",
  },
}

local rightSwitchLay = {
  MaterialSwitch,
  id="switchView",
  layout_marginLeft=0,
  layout_marginRight="16dp",
}

local rightCardLay = {
  MaterialCardView,
  id="cardView",
  h="36dp",
  w="36dp",
  radius="360dp",
  layout_marginLeft=0,
  layout_marginRight="16dp",
}

local rightNewPageIconLay = {
  AppCompatImageView,
  id="rightIcon",
  layout_margin="16dp",
  layout_marginLeft=0,
  layout_width="24dp",
  layout_height="24dp",
  colorFilter=Colors.colorOutline,
}

_M.leftIconLay = leftIconLay
_M.leftCoverLay = leftCoverLay
_M.leftCoverIconLay = leftCoverIconLay
_M.oneLineLay = oneLineLay
_M.twoLineLay = twoLineLay
_M.rightSwitchLay = rightSwitchLay
_M.rightNewPageIconLay = rightNewPageIconLay

local itemsLay = {

  {--标题
    LinearLayoutCompat,
    layout_width="fill",
    focusable=true,
    {
      AppCompatTextView,
      id="title",
      textSize=TextSize,
      textColor=Colors.colorPrimary,
      layout_margin="8dp",
      gravity="center|left",
      layout_marginLeft="20dp",
      Typeface=Typeface_TTF(),
    },
  },

  {--设置项(图片,标题,简介)
    LinearLayoutCompat,
    layout_width="fill",
    gravity="center",
    focusable=true,
    leftIconLay,
    twoLineLay,
    rightNewPageIconLay,
  },

  {--设置项(图片,标题)
    LinearLayoutCompat,
    layout_width="fill",
    gravity="center",
    focusable=true,
    leftIconLay,
    oneLineLay,
    rightNewPageIconLay,
  },

  {--设置项(图片,标题,简介,开关)
    LinearLayoutCompat,
    gravity="center",
    layout_width="fill",
    focusable=true,
    leftIconLay,
    twoLineLay,
    rightSwitchLay,
  },

  {--设置项(图片,标题,开关)
    LinearLayoutCompat,
    gravity="center",
    layout_width="fill",
    focusable=true,
    leftIconLay,
    oneLineLay,
    rightSwitchLay,
  },

  {--设置项(头像,标题,简介)
    LinearLayoutCompat,
    layout_width="fill",
    gravity="center",
    focusable=true,
    leftCoverLay,
    twoLineLay,
    rightNewPageIconLay,
  },

  {--设置项(简介)
    LinearLayoutCompat,
    gravity="center",
    layout_width="fill",
    focusable=false,
    {
      AppCompatTextView,
      gravity="center",
      layout_weight=1,
      layout_margin="16dp",
      layout_width="fill",
      textSize=TextSize,
      Typeface=Typeface_TTF(),
      id="summary",
    },
  },

  {--设置项(图片,标题,卡片)
    LinearLayoutCompat,
    gravity="center",
    layout_width="fill",
    focusable=true,
    leftIconLay,
    oneLineLay,
    rightCardLay,
  },

  {--设置项(标题,简介)
    LinearLayoutCompat,
    layout_width="fill",
    gravity="center",
    paddingLeft="8dp",
    focusable=true,
    twoLineLay,
  },

  {--设置项(标题,简介,开关)
    LinearLayoutCompat,
    layout_width="fill",
    gravity="center",
    paddingLeft="6dp",
    focusable=true,
    twoLineLay,
    rightSwitchLay,
  },

}

_M.itemsLay = itemsLay
_M.itemsNumber = #itemsLay

local function setAlpha(views,alpha)

  for index,content pairs(views)

    if content

      content.setAlpha(alpha)

    end
  end
end

_M.setAlpha = setAlpha

local function onItemViewClick(view)

  local ids = view.tag
  local viewConfig = ids._config
  local data = ids._data
  local key = data.key
  local onItemClick = viewConfig.onItemClick

  viewConfig.allowedChange = false

  local switchView = ids.switchView

  if switchView and viewConfig.switchEnabled

    local checked = not(switchView.checked)
    switchView.setChecked(checked)

    if data.checked ~= nil
      data.checked = checked
     elseif data.key
      this.setSharedData(data.key,checked)
    end

  end

  if onItemClick
    onItemClick(view,ids,key,data)
  end

  viewConfig.allowedChange = true

  return true
end
local onItemViewClickListener = View.OnClickListener({onClick = onItemViewClick})

local function onItemViewLongClick(view)

  local ids = view.tag
  local viewConfig = ids._config
  local data = ids._data
  local key = data.key
  local result
  local onItemLongClick = viewConfig.onItemLongClick
  viewConfig.allowedChange = false

  if onItemLongClick
    result = onItemLongClick(view,ids,key,data)
  end

  viewConfig.allowedChange = true

  return result
end

local function onSwitchCheckedChanged(view,checked)

  local viewConfig = view.tag
  local allowedChange = viewConfig.allowedChange

  if allowedChange

    local key = viewConfig.key
    local data = viewConfig.data
    local onItemClick = viewConfig.onItemClick

    if data.checked ~= nil
      data.checked = checked
     elseif data.key
      this.setSharedData(data.key,checked)
    end

    if onItemClick
      onItemClick(viewConfig.itemView,viewConfig.ids,key,data)
    end

  end
end

local adapterEvents = {

  getItemCount = function(data)

    return #data

  end,

  getItemViewType = function(data,position)

    local itemData = data[position+1]
    itemData.position = position
    return itemData[1]

  end,

  onCreateViewHolder = function(onItemClick,onItemLongClick,parent,viewType)

    local ids = {}
    local view = Layout.inflate(itemsLay[viewType],ids)
    local holder = LuaCustRecyclerHolder(view)

    view.setTag(ids)

    local viewConfig = {enabled = true,
      switchEnabled = true,
      onItemClick = onItemClick,
      onItemLongClick = onItemLongClick,
      itemView = view,
      ids = ids}
    ids._config = viewConfig

    if viewType ~=1

      local switchView = ids.switchView
      view.setFocusable(true)
      view.setBackground(ColorUtil.getRipple(true))
      view.setOnClickListener(onItemViewClickListener)
      view.setOnLongClickListener(this.onLongClickX(onItemViewLongClick))

      if switchView

        switchView.tag = viewConfig
        switchView.setOnCheckedChangeListener({
          onCheckedChanged = onSwitchCheckedChanged
        })

      end

    end
    return holder
  end,

  onBindViewHolder = function(data,holder,position)

    local data = data[position+1]
    local layoutView = holder.view
    local ids = layoutView.getTag()
    local viewConfig = ids._config
    ids._data = data
    local title = data.title
    local icon = data.icon
    local summary = data.summary
    local enabled = data.enabled
    local switchEnabled = data.switchEnabled
    local key = data.key
    local action = data.action
    local chooseItems = data.items
    viewConfig.key = key
    viewConfig.data = data
    viewConfig.allowedChange = false

    --Views
    local titleView = ids.title
    local summaryView = ids.summary
    local switchView = ids.switchView
    local rightIconView = ids.rightIcon
    local iconView = ids.icon
    local cardView = ids.cardView

    if title and titleView

      titleView.setText(title)

    end

    if summaryView

      if summary

        summaryView.setText(summary)

       elseif key == "theme_light_dark" or key == "item_list_columns" or key == "theme_color" or key == "layouthelper_dialog" or key == "global_font_size" or key == "signature_scheme"

        summaryView.setText(chooseItems[this.getSharedData(key)])

       elseif action == "singleChoose"

        summaryView.setText(chooseItems[(this.getSharedData(key) or 0)+1])

       elseif action == "custom_symbol_bar" or action == "custom_syntax_highlighting"

        summaryView.setText(this.getSharedData(action))
        summaryView.setMaxLines(4)

      end

    end

    if cardView

      if action == "keyword_color" or action == "userword_color" or action == "baseword_color" or action == "string_color" or action == "comment_color"

        cardView.setCardBackgroundColor(this.getSharedData(action))

      end

    end

    if icon and iconView

      if qq or icon:find("%/")
        GlideUtil.setImage(icon, iconView)
       else
        GlideUtil.setImage(this.getLuaDir("res/drawable/"..icon..".png"), iconView)
      end

    end

    --设置启用状态透明
    local enabledNotFalse = not(enabled == false)
    local switchEnabledNotFalse = not(switchEnabled == false)

    if viewConfig.enabled ~= enabledNotFalse
      viewConfig.enabled = enabledNotFalse
      layoutView.setEnabled(enabledNotFalse)

      local viewsList = {titleView,summaryView,iconView,rightIconView}

      if enabledNotFalse
        setAlpha(viewsList,1)
       else
        setAlpha(viewsList,0.5)
      end

    end

    if viewConfig.switchEnabled ~= switchEnabledNotFalse
      viewConfig.switchEnabled = switchEnabledNotFalse
      if switchView
        switchView.setEnabled(switchEnabledNotFalse)
      end
    end

    if switchView

      if data.checked ~= nil
        switchView.setChecked(data.checked)
       elseif data.key
        switchView.setChecked(this.getSharedData(key) or false)
       else
        switchView.setChecked(false)
      end

    end

    if rightIconView

      local newPage = data.newPage
      local visibility = rightIconView.getVisibility()

      if newPage
        if newPage == "newApp"
          GlideUtil.setImage(this.getLuaDir("res/drawable/ic_launch.png"),rightIconView)
         else
          GlideUtil.setImage(this.getLuaDir("res/drawable/ic_chevron_right.png"),rightIconView)
        end
        if visibility ~= View.VISIBLE
          rightIconView.setVisibility(View.VISIBLE)
        end
       else
        if visibility ~= View.GONE
          rightIconView.setVisibility(View.GONE)
        end
      end

    end

    viewConfig.allowedChange = true

  end,
}
_M.adapterEvents = adapterEvents

function _M.newAdapter(data,onItemClick,onItemLongClick)

  return LuaCustRecyclerAdapter(AdapterCreator({
    getItemCount = function()

      return adapterEvents.getItemCount(data)

    end,

    getItemViewType = function(position)

      return adapterEvents.getItemViewType(data,position)

    end,

    onCreateViewHolder = function(parent,viewType)

      return adapterEvents.onCreateViewHolder(onItemClick,onItemLongClick,parent,viewType)

    end,

    onBindViewHolder = function(holder,position)

      adapterEvents.onBindViewHolder(data,holder,position)

    end,
  }))

end


return _M