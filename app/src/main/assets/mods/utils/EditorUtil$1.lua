local _M = {}
local ViewId = {}
local ColorUtil = require "mods.utils.ColorUtil"

local function copy(str)

  this.getSystemService("clipboard").setText(str)

end

local allMoveView = function()

  return pcall(function()

    for _, v ipairs(ViewId)

      ps_bar.removeView(v.item)

    end

    ViewId = {}

  end)

end

local addView = function(list)

  local MaterialTextView = bindClass "com.google.android.material.textview.MaterialTextView"
  local PopupMenu = bindClass "androidx.appcompat.widget.PopupMenu"

  return pcall(function()
    ViewId[#ViewId + 1] = {}
    local text = string.match(list[1],"%w+$")
    local Item = loadlayout({
      MaterialTextView,
      id="item",
      layout_height="45dp",
      gravity="center",
      textColor=Colors.colorOnBackground,
      text=text .. "[".. #list .. "]",
      paddingRight="12dp",
      paddingLeft="12dp",
      textSize=TextSize + 1,
      Typeface=Typeface_TTF(),
      clickable=true,
      backgroundDrawable=ColorUtil.getRipple(),
      singleLine=true,
      onClick=function(v)

        local popupMenu = PopupMenu(this, v)
        local popupMenux = PopupMenu(this, v)

        local list = luajava.astable(list)

        for k,v ipairs(list)

          local paths = tostring(v)

          popupMenu.Menu.add(setFontSize(TypefaceString(paths), TextSize + 2)).onMenuItemClick=function()

            popupMenux.Menu.add(setFontSize(TypefaceString(res.string.copy_classes), TextSize + 2)).onMenuItemClick=function()

              copy(string.format('local %s = luajava.bindClass "%s"', text , paths))
              allMoveView()

            end

            popupMenux.Menu.add(setFontSize(TypefaceString(res.string.see_api), TextSize + 2)).onMenuItemClick=function()
              
              ActivityUtil.new("Parsing", { paths })

              allMoveView()

            end

            popupMenux.show()

          end
        end

        popupMenu.show()

      end
    },ViewId[#ViewId])
    ps_bar.addView(Item, 0)
  end)
end

_M.javaClassAnalyse = function(view, status)

  if view.getSelectedText() and status

    local text = view.getSelectedText()

    if utf8.len(text) == 10 and utf8.sub(utf8.upper(text), 1, 2) == "0X"

      card.setCardBackgroundColor(tonumber(text))

      card.setVisibility(0)

     elseif utf8.len(text) == 6

      if view.getSelectionStart() - 1 ~= -1

        view.setSelection(view.getSelectionStart() - 1, 7)

        if utf8.sub(view.getSelectedText(), 1, 1) == "#"

          card.setCardBackgroundColor(tonumber("0xFF"..utf8.sub(view.getSelectedText(), 2, -1)))

          card.setVisibility(0)

         else

          view.setSelection(view.getSelectionStart() + 1, 6)

        end

      end

    end

    this.newTask(function(text)

      local classes = require "activities.JavaApi.PublicClasses"

      local Import_class = {}

      for k,v ipairs(classes)

        local z = tostring(string.match(v,"%w+$"))

        if z == text and

          table.insert(Import_class, v)

        end

      end

      return Import_class

      end,function(Import_class)

      if #Import_class ~= 0

        addView(Import_class)

      end

    end).execute({ text })

   else

    card.setVisibility(8)

    allMoveView()

  end

end

return _M