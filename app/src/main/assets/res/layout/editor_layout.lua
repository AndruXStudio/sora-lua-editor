local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local DrawerLayout = bindClass "androidx.drawerlayout.widget.DrawerLayout"
local LuaEditor = bindClass "com.androlua.LuaEditor"
local FrameLayout = bindClass "android.widget.FrameLayout"
local TabLayout = bindClass "com.google.android.material.tabs.TabLayout"
local MaterialDivider = bindClass "com.google.android.material.divider.MaterialDivider"
local FloatingActionButton = bindClass "com.google.android.material.floatingactionbutton.FloatingActionButton"
local HorizontalScrollView = bindClass "android.widget.HorizontalScrollView"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local SwipeRefreshLayout = bindClass "androidx.swiperefreshlayout.widget.SwipeRefreshLayout"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local LuaFileTabView = require "mods.view.LuaFileTabView"
local FunctionUtil = require "mods.utils.FunctionUtil"--快捷功能栏工具类

return {
  LinearLayoutCompat,
  w="fill",
  h="fill",
  orientation="vertical",
  {
    AppBarLayout,
    w="fill",
    backgroundColor=colorToolBar,
    {
      MaterialToolbar,
      w="fill",
      id="toolbar",
      title=TypefaceString(res.string.app_name),
      layout_scrollFlags=3,
    },
    {
      HorizontalScrollView,
      h="32dp",
      w="fill",
      id="function_menu_root",
      Visibility=8,
      horizontalScrollBarEnabled=false,
      {
        LinearLayoutCompat,
        h="fill",
        w="fill",
        backgroundColor=colorToolBar,
        id="function_menu",
        paddingLeft="2dp",
        paddingRight="2dp",
      },
    },
    {
      TabLayout,
      backgroundColor=colorToolBar,
      w="fill",
      h="36dp",
      TabMode=0,
      id="mTab",
    },
    {
      MaterialDivider,
    }
  },
  {
    DrawerLayout,
    id="drawer",
    h="fill",
    w="fill",
    {
      LinearLayoutCompat,
      w="fill",
      h="fill",
      orientation="vertical",
      layoutTransition=mTransition,
      {
        FrameLayout,
        h="fill",
        w="fill",
        layout_weight=1,
        layoutTransition=mTransition,
        {
          LuaEditor,
          id="mLuaEditor",
          h="fill",
          w="fill",
        },
        {
          MaterialCardView,
          layout_gravity="end",
          h="30dp",
          w="30dp",
          radius="360dp",
          id="card",
          layout_margin="8dp",
          Visibility=8,
        },
        {
          LinearLayoutCompat,
          orientation="vertical",
          layout_gravity="bottom|end",
          {
            FloatingActionButton,
            id="fab1",
            Visibility=8,
            ImageDrawable=res.drawable.ic_add,
            TooltipText=TypefaceString(res.string.new),
            layout_margin="16dp",
            layout_marginBottom=0,
            onClick=function()

              FunctionUtil.OpenGreateDialog()

            end,
          },
          {
            FloatingActionButton,
            id="fab2",
            Visibility=8,
            ImageDrawable=res.drawable.ic_drive_file_rename_outline,
            TooltipText=TypefaceString(res.string.formatting),
            layout_margin="16dp",
            layout_marginBottom=0,
            onClick=function()
              mLuaEditor.format()
            end,
          },
          {
            FloatingActionButton,
            id="fab3",
            TooltipText=TypefaceString(res.string.menu),
            ImageDrawable=res.drawable.ic_chevron_top,
            layout_margin="16dp",
            onClick=function(v)
              if fab1.Visibility == 8

                v.setImageDrawable(res.drawable.ic_chevron_bottom)
                fab1.setVisibility(0)
                fab2.setVisibility(0)

               elseif fab1.Visibility == 0

                v.setImageDrawable(res.drawable.ic_chevron_top)
                fab1.setVisibility(8)
                fab2.setVisibility(8)

              end
            end,
          },
        },
      },
      {
        LinearLayoutCompat,
        w="fill",
        orientation="vertical",
        {
          MaterialDivider,
        },
        {
          HorizontalScrollView,
          backgroundColor=colorToolBar,
          horizontalScrollBarEnabled=false,
          w="fill",
          {
            LinearLayoutCompat,
            w="fill",
            id="ps_bar",
            layoutTransition=mTransition,
          },
        },
      },
    },
    {
      LinearLayoutCompat,
      layout_gravity="left",
      orientation="vertical",
      w="76%w",
      h="fill",
      backgroundColor=Colors.colorBackground,
      {
        LuaFileTabView,
        id="filetab",
        w="match",
        h="48dp",
        tabMode=0,
        selectedTabIndicatorHeight=0,
        inlineLabel=true,
        canSelectTab=false,
        clipToPadding=false,
      },
      {
        SwipeRefreshLayout;
        h="fill",
        w="fill",
        id="swipeRefresh",
        {
          RecyclerView,
          w="fill",
          h="fill",
          id="mRecycler",
        },
      },
    },
  },
}