local bindClass = luajava.bindClass
local LuaCustRecyclerAdapter = bindClass "github.znzsofficial.adapter.LuaCustRecyclerAdapter"
local LuaCustRecyclerHolder = bindClass "github.znzsofficial.adapter.LuaCustRecyclerHolder"
local utf8 = utf8
local utf8_sub = utf8.sub
local loadlayout = loadlayout

return lambda (context, data, item, interface):
LuaCustRecyclerAdapter(context, {
  getItemCount = function()
    return #data;
  end,

  getItemViewType = interface.getItemViewType 
  or ( lambda () -> 0 ),

  getPopupText = interface.getPopupText
  or ( lambda (view, pos) -> utf8_sub(data[pos + 1], 1, 1) ),

  onViewRecycled = interface.getViewRecycled
  or ( lambda () -> nil ),

  onCreateViewHolder = function(parent, viewType)
    local views = {}
    local viewHolder = LuaCustRecyclerHolder(
    loadlayout(item, views) )
    viewHolder.setTag(views)

    if interface.onCreateViewHolder then
      interface.onCreateViewHolder(parent, viewType, viewHolder, views)
    end

    return viewHolder
  end,

  onBindViewHolder = function(viewHolder, pos)
    local views = viewHolder.getTag()
    interface.onBindViewHolder(viewHolder, pos,
    views, data[pos + 1])
  end
})