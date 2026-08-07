require "environment"
local PageView = bindClass "android.widget.PageView"
local ArrayPageAdapter = bindClass "android.widget.ArrayPageAdapter"
local KeyEvent = bindClass "android.view.KeyEvent"
local agreements = require "activities.Welcome.WelcomeActivity$data"
local agreementPage = require "activities.Welcome.WelcomeActivity$agreementPage"
local permissionPage = require "activities.Welcome.WelcomeActivity$permissionPage"
local ActivityUtil = require "mods.utils.ActivityUtil"

this {
  Title = TypefaceString(res.string.welcome),
  ContentView = res.view.welcome_layout,
}

ScreenFixContent = {
  layoutManagers = {},
  orientation = {
  }
}

pages = {}

onConfigurationChanged = function(config)

  for index,content ipairs(pages)

    if content.onConfigurationChanged

      content:onConfigurationChanged(config)

    end

  end
end

onKeyDownX(function()

  local nowPage = pageView.getCurrentItem()

  if nowPage == 0

    this.finish()

   elseif nowPage > 0

    pageView.showPage(nowPage-1)
    return true

  end
end)

for index,content in ipairs(agreements)

  table.insert(pages, agreementPage(content.title,content.icon,content.name,content.date))

end

table.insert(pages,permissionPage)


NowPage = pages[1]

maxPage = table.size(pages)

adp = ArrayPageAdapter()

for index,content in ipairs(pages)

  adp.add(loadlayout(content.layout, content))

  if content.onInitLayout
    content:onInitLayout()
  end

end

pageView.setAdapter(adp)

pageView.setOnPageChangeListener(PageView.OnPageChangeListener{
  onPageChange=function(view,page)

    local nowPage = pages[page+1]
    local elevationKey = nowPage.elevationKey
    NowPage = nowPage

    if page+1 == maxPage
      nextButton.setText(res.string.step_finish)
     else
      nextButton.setText(res.string.step_next)
    end

    if page==0
      previousButton
      { Clickable = false,
        Visibility = 8 }
     else
      previousButton
      { Clickable = true,
        Visibility = 0 }
    end

    nextButton.setEnabled(not(nowPage.allowNext==false))

    title.Text = nowPage.title

    if nowPage.subtitle
      subtitle
      { Text = nowPage.subtitle,
        Visibility = 0
      }

     else
      subtitle
      { Text = "",
        Visibility = 8 }
    end

    titleicon
    { ImageBitmap = loadbitmap("res/drawable/"..nowPage.icon..".png"),
      ColorFilter = Colors.colorPrimary }

    title.setTextColor(Colors.colorPrimary)

  end
})

previousButton.onClick = function()
  local nowPage = pageView.getCurrentItem()
  if nowPage > 0
    pageView.showPage(nowPage-1)
  end
end

nextButton.onClick = function()

  local nowPage = pageView.getCurrentItem()+1
  if nowPage < maxPage

    pageView.showPage(nowPage)

   elseif nowPage >= maxPage

    enteringProgressBar.setVisibility(0)
    nextButton.setVisibility(4)
    
    this.setSharedData("welcome", true)
    ActivityUtil.new("Main")
    this.finish()

  end
end

onConfigurationChanged(this.getResources().getConfiguration())

this.setSharedData("showtaptarget", true)