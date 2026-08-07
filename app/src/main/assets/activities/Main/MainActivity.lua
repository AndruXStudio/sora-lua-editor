require "environment"
local WindowManager = bindClass "android.view.WindowManager"
local AccelerateInterpolator = bindClass "android.view.animation.AccelerateInterpolator"
local DecelerateInterpolator = bindClass "android.view.animation.DecelerateInterpolator"
local DrawableUtil = require "mods.utils.DrawableUtil"
local ChooseUtil = require "mods.utils.ChooseUtil"
local LottieDrawable = require "mods.utils.LottieDrawable"
local FragmentUtil = require "mods.utils.FragmentUtil"
local MyFragment = require "activities.Main.MainActivity$my"
local MySearchBar = require "mods.view.MySearchBar"
local PermissionUtil = require "activities.Welcome.WelcomeActivity$1"
ProjectFragment = require "activities.Main.MainActivity$project"
ActivityUtil = require "mods.utils.ActivityUtil"

PermissionUtil.askForRequestPermissions({
  {
    permissions = {
      "android.permission.WRITE_EXTERNAL_STORAGE",
      "android.permission.READ_EXTERNAL_STORAGE"
    }
  }
})

this.getWindow()
.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN)

ProjectListMode = this.getSharedData("item_list_columns") or 1

this {
  Title = res.string.app_name,
  ContentView = res.view.activity_main,
  SupportActionBar = toolbar
}

onCreateOptionsMenu = function(menu)

  menu.add(TypefaceString(res.string.search))
  .setShowAsAction(2)
  .setIcon(DrawableUtil("ic_search",Colors.colorOnSurfaceVariant))
  .onMenuItemClick=function()

    if FragmentUtil.getCurrentltem() != 3

      switch search.getVisibility()
       case 8
        search.setVisibility(0)
       case 0
        search.setVisibility(8)
      end

    end

  end

  menu.add(setFontSize(TypefaceString(res.string.import_source), TextSize + 2))
  .onMenuItemClick=function()

    ChooseUtil.show(1)

  end

  menu.add(setFontSize(TypefaceString(res.string.setting), TextSize + 2))
  .onMenuItemClick=function()

    ActivityUtil.new("Setting")

  end

end

bottombar.post{
  run = function()

    local margin = dp2px(16)
    local h = bottombar.getHeight()

    fab.getLayoutParams().setMargins(0,0,margin,h+margin)

    pull_project.getLayoutParams().setMargins(0,0,0,(function()

      if this.getSharedData("slide_hide")

        return dp2px(14)

       else

        return h

      end

    end)())

  end
}

local menu=
{
  { title = setFontSize(TypefaceString(res.string.project), TextSize - 1.5) },
  { title = setFontSize(TypefaceString(res.string.source), TextSize - 1.5 ) },
  { title = setFontSize(TypefaceString(res.string.my), TextSize - 1.5) }
}

for k,v pairs(menu)

  bottombar.Menu
  .add(0,k-1,k-1,v.title)

end

local drawables = {
  "ic_dashboard", "ic_store", "ic_others"
}

local menu = bottombar.menu
local key = KeyPath { "**" }

for i = 1, menu.size()

  local item = menu.getItem(i - 1)
  item.setIcon(LottieDrawable(drawables[i])
  .addValueCallback(key, LottieProperty.COLOR_FILTER,
  SimpleLottieValueCallback { function getValue()
      local color = item.isChecked()
      && Colors.colorPrimary || Colors.colorOutline
      return SimpleColorFilter(color)
  end }))

end

menu.findItem(bottombar.selectedItemId)
.icon.setMinFrame(10).setMaxFrame(20).playAnimation()
menu.getItem(0).icon.setMinFrame(0).setMaxFrame(10).playAnimation()

bottombar.setOnNavigationItemSelectedListener(bindClass "com.google.android.material.bottomnavigation.BottomNavigationView".OnNavigationItemSelectedListener{
  onNavigationItemSelected = function(item)

    if bottombar.selectedItemId == item.itemId return true end
    search.setVisibility(8)

    if item.getItemId() == 2 fab.hide() else fab.show() end

    menu.findItem(bottombar.selectedItemId)
    .icon.setMinFrame(10).setMaxFrame(20).playAnimation()
    item.icon.setMinFrame(0).setMaxFrame(10).playAnimation()

    FragmentUtil.showFragment(item.getItemId())

    return true

  end
})

if this.getSharedData("slide_hide")

  appBar.addOnOffsetChangedListener(bindClass "com.google.android.material.appbar.AppBarLayout".OnOffsetChangedListener{
    onOffsetChanged = function(appBarLayout, verticalOffset)

      if (Math.abs(verticalOffset) - appBarLayout.getTotalScrollRange() == 0)
        fab.animate().translationY(fab.getHeight() + fab.getLayoutParams().bottomMargin).setInterpolator(AccelerateInterpolator(3))
       else
        fab.animate().translationY(0).setInterpolator(DecelerateInterpolator(3))
      end

  end})

  bottombar.getLayoutParams().setBehavior(newInstance "com.load.LuaAppX.behavior.BottomNavigationViewBehavior")

end

local KeyEvent = bindClass "android.view.KeyEvent"

search
.getView()
.setOnKeyListener{
  onKey=function(v,keyCode,event)

    if keyCode == 66 and event.getAction() == 0
      ProjectFragment.getProjectList(tostring(search.getText()))
      return true
    end

  end
}

fab.onClick = function()

  switch FragmentUtil.getCurrentltem()
   case 1
    ActivityUtil.new("NewProject")
  end

end

FragmentUtil = FragmentUtil(fragment)
.addFragment(res.view.fragment_project)
.addFragment(res.view.fragment_source)
.addFragment(res.view.fragment_my)
.commitFragment()

ProjectFragment.onCreate()
MyFragment.onCreate()

function onResult(name,str)

  local name = File(name).Name

  switch name

   case "NewProjectActivity"

    ProjectFragment.updata()

    MyToast(str)

   case "LoginActivity"

    MyToast(str)

    Get_Infor()

   case "SettingActivity"

    finish()
    ActivityUtil.new("Main")
    ActivityUtil.new("Setting")

  end

end