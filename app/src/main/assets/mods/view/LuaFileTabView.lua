local class = require "modules.class"
local TabLayout = bindClass "com.google.android.material.tabs.TabLayout"
local String = bindClass "java.lang.String"
local table = table
local luajava_astable = luajava.astable
local table_remove = table.remove
local table_size = table.size
local table_concat = table.concat

-- private data
local my_path = ""
local onTabSelected = lambda():;
local select_tab = true
--

local splitPath = function(path)

  local t = luajava_astable(String(path).split("/"))

  table_remove(t,1)

  return t

end

local addListener = function(view)
  view.addOnTabSelectedListener({
    onTabSelected = function(tab)

      local count = view.getTabCount()
      local position = tab.getPosition()
      local now_array = splitPath(my_path)

      if position < count-1

        for i=1,count - position - 1

          view.removeTabAt(view.getTabCount()-1)

          table_remove(now_array)

        end

        my_path = "/" .. table_concat(now_array,"/")

      end

      return onTabSelected(tab)

    end

  })
end

return class{
  extends = TabLayout,
  init = addListener,
  methods = {
    setPath = function(view,path,select)

      path = string.match(path, PathUtil.project_dir .. "(.+)")

      local now_array = splitPath(path)
      local last_array = splitPath(my_path)
      local now_array_size = table_size(now_array)
      local last_array_size = table_size(last_array)

      if now_array_size <= last_array_size

        for i=0,last_array_size - now_array_size

          view.removeTabAt(view.getTabCount() - 1)

        end

      end

      for k,v ipairs(now_array)

        local tab = view.getTabAt(k-1)

        if not tab

          tab = view.newTab()

          if k != 1 tab.setIcon(MDC_R.drawable.abc_ic_go_search_api_material) end

          view.addTab(tab)

        end

        tab.setText(setFontSize(TypefaceString(v, 3), TextSize + 2))

        local tab_view = tab.view

        if not select_tab

          tab_view.setOnTouchListener(lambda():true)

        end

        local textView = tab_view.getChildAt(1)

        textView.setAllCaps(false)

      end

      local finalTab = view.getTabAt(view.getTabCount()-1)

      local finalTabView = finalTab.view

      if select != false

        finalTabView.post({
          run = function(...)

            finalTab.select()

          end
        })
      end

      my_path = path

    end,

    getPath = lambda():my_path;,

    setOnTabSelected = function(view,func)

      onTabSelected = func

      return view

    end,

    setCanSelectTab = function(view,b)

      select_tab = b

      return view

    end
  },
}