local _M = {}
local PopupMenu = bindClass "androidx.appcompat.widget.PopupMenu"
local LuaFileUtil = require "mods.utils.LuaFileUtil"

local tabTable = {}

function _M.add(path)

  tabTable[path] = tabTable[path] or {}

  if not tabTable[path].showed

    local tab = mTab.newTab()

    local pathName = File(path).getName()

    tab.setText(setFontSize(TypefaceString(pathName, 3), TextSize + 2))

    local view = tab.view

    view.setOnLongClickListener(this.onLongClickX(function()

      local popupMenu = PopupMenu(this, view)
      local menu = popupMenu.getMenu()

      menu.add(setFontSize(TypefaceString(res.string.close_file),TextSize + 2)).onMenuItemClick = function()

        if mTab.getTabCount() == 1

          MyToast(res.string.must_one)
          return true

         else

          for i pairs(tabTable)

            local _o = tabTable[i].o

            LuaFileUtil.write(PathUtil.this_file, tostring(mLuaEditor.getText()))

            if _o == tab

              tabTable[i].showed=nil
              tabTable[i]=nil
              mTab.removeTab(_o)

            end

          end
        end
      end

      menu.add(setFontSize(TypefaceString(res.string.close_other),TextSize + 2)).onMenuItemClick = function()
        
        if mTab.getTabCount() == 1
          
          MyToast(res.string.no_other)
          return true
          
         else
         
          for i pairs(tabTable)
            
            local _o = tabTable[i].o
            
            LuaFileUtil.write(PathUtil.this_file, tostring(mLuaEditor.getText()))
            
            if _o ~= tab
              
              tabTable[i].showed=nil
              tabTable[i]=nil
              mTab.removeTab(_o)
              
            end
          end
        end
      end
    
    

      popupMenu.show()

      return true

    end))

    tabTable[path].o=tab
    tabTable[path].o.tag=path
    tabTable[path].showed=true

    mTab.addTab(tab,mTab.getTabCount())

    local finalTab = mTab.getTabAt(mTab.getTabCount()-1)
    local finalTabView = finalTab.view
    if select != false
      finalTabView.post({
        run = function(...)

          tab.select()

        end
      })
    end

   else

    local finalTab = mTab.getTabAt(mTab.getTabCount()-1)
    local finalTabView = finalTab.view
    if select != false
      finalTabView.post({
        run = function(...)

          tabTable[path].o.select()

        end
      })
    end

  end

end

function _M.remove(path)

  if tabTable[path] ~= nil

    mTab.removeTab(tabTable[path].o)

    tabTable[path] = nil

  end

end

function _M.checkAll()

  for i pairs(tabTable)

    if not File(tabTable[i].o.tag).exists()

      _M.remove(tabTable[i].o.tag)

    end

  end

end

return _M