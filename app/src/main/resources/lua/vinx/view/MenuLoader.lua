local IDS = luajava.ids

local _M = {}

local SHOW_AS_ACTION_FLAGS = {
  never = 0,
  ifRoom = 1,
  always = 2,
  withText = 4,
  collapseActionView = 8,
}

local function toConstant(value, t)
  --print(value)
  if type(value) == "number" return value end   
  local ret = 0
  for n in (value.."|"):gmatch("(.-)|") do
    local s = t[n]
    if t[n] then
      ret = ret | s
     else
      return nil
    end
  end
  return ret
end

local ATTRIBUTE_SETTER = {
  function icon(item, icon)
    item.setIcon(icon)
  end,
  
  function showAsAction(item, pos)
    item.setShowAsAction(pos)
  end,
  
  function showAsActionFlags(item, flags)
    item.setShowAsActionFlags(
      toConstant(flags, SHOW_AS_ACTION_FLAGS))
  end,
  
  function actionProvider(item, provider)
    item.setActionProvider(provider)
  end,
  
  function actionView(item, view)
    item.setActionView(view)
  end,
  
  function alphabeticShortcut(item, value)
    item.setAlphabeticShortcut(value)
  end,
  
  function checkable(item, checkable)
    item.setCheckable(checkable)
  end,
  
  function checked(item, checked)
    item.setChecked(checked)
  end,
  
  function contentDescription(item, desc)
    item.setContentDescription(desc)
  end,
  
  function enabled(item, enabled)
    item.setEnabled(enabled)
  end,
 
  function iconTintBlendMode(item, mode)
    item.setIconTintBlendMode(mode)
  end,
  
  function iconTintList(item, list)
    item.setIconTintList(list)
  end,
  
  function iconTintMode(item, mode)
    item.setIconTintMode(mode)
  end,
  
  function intent(item, intent)
    item.setIntent(intent)
  end,
  
  function numericShortcut(item, value)
    item.setNumericShortcut(value)
  end,
  
  function onActionExpand(item, listener)
    item.setOnActionExpandListener(listener)
  end,
  
  function onMenuItemClick(item, listener)
    item.setOnMenuItemClickListener(listener)
  end,
 
  function shortcut(item, value)
    item.setShortcut(value)
  end,
  
  function titleCondensed(item, title)
    item.setTitleCondensed(title)
  end,
  
  function tooltipText(item, text)
    item.setTooltipText(text)
  end,
  
  function visible(item, visible)
    item.setVisible(visible)
  end,
  
  
  -- ActionMenuItem
  function exclusiveCheckable(item, checkable)
    item.setExclusiveCheckable(checkable)
  end,
  
  function supportActionProvider(item, provider)
    item.setSupportActionProvider(provider)
  end,
  
  
  -- SubMenu
  function headerIcon(item, icon)
    item.setHeaderIcon(icon)
  end,
  
  function headerTitle(item, title)
    item.setHeaderTitle(title)
  end,
  
  function headerView(item, view)
    item.setHeaderView(view)
  end,
  
  function groupDividerEnabled(item, enabled)
    item.setGroupDividerEnabled(enabled)
  end,
  
  function callback(item, callback)
    item.setCallback(callback)
  end,
  
  function qwertyMode(item, mode)
    item.setQwertyMode(mode)
  end,
  
  function shortcutsVisible(item, visible)
    item.setShortcutsVisible(visible)
  end,
  
  -- Menu
  function groupCheckable(item, t)
    item.setGroupCheckable(t[1], t[2], t[3])
  end,
  
  function groupEnabled(item, t)
    item.setGroupEnabled(t[1], t[2])  
  end,
  
  function groupVisible(item, t)
    item.setGroupVisible(t[1], t[2])  
  end
}

_M.loadInto = function(menu, t, env)
  local env = env or _G
  for k, v in pairs(t) do  
    if type(v) == "string" then
      ATTRIBUTE_SETTER[k](menu, v)
    end
    if type(v) ~= "table" continue end
    local item
    -- SubMenu
    local id = v.menuId or IDS.id
    IDS.id = IDS.id + 1
        
    if v[1] then
      item = menu.addSubMenu(
        v.group or 0, id,
        v.order or 0,v.title
      )
      _M.loadInto(item, v, env)      
    -- MenuItem
     else
      item = menu.add(
        v.group or 0, id,
        v.order or 0, v.title
      )
    end
    
    for i, j in pairs(v) do
      switch i do
       case "id"
        rawset(env, v.id, item)
        rawset(IDS, v.id, id)
       case "group", "menuId", "order", "title"
        continue
       default
        ATTRIBUTE_SETTER[i](item, j)
      end
    end
  end
  
  return true
end

_M.load = function(t)
  _M.loadInto(t[1], t)
end

return _M