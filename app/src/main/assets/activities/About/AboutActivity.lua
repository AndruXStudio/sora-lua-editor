require "environment"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local Intent = bindClass "android.content.Intent"
local Uri = bindClass "android.net.Uri"
local TypefaceSpan = bindClass "android.text.style.TypefaceSpan"
local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
local SpannableString = bindClass "android.text.SpannableString"
local Spannable = bindClass "android.text.Spannable"
local SpannableStringBuilder = bindClass "android.text.SpannableStringBuilder"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local SettingsLayUtil = require "mods.utils.SettingsLayUtil"
local PluginsUtil = require "mods.utils.PluginsUtil"
local ActivityUtil = require "mods.utils.ActivityUtil"
local agreements = require "activities.Welcome.WelcomeActivity$data"

local PackInfo = this.PackageManager.getPackageInfo(this.getPackageName(),64)

this {
  Title = res.string.about_title,
  ContentView = res.view.about_layout,
  SupportActionBar = toolbar
}
.getSupportActionBar()
{
  DisplayHomeAsUpEnabled = true
}

onOptionsItemSelected = function(v)

  if v.getItemId() == android.R.id.home

    finish()

  end

end

local openInBrowser = function(url)

  local intent = Intent("android.intent.action.VIEW", Uri.parse(url))

  if intent.resolveActivity(this.getPackageManager())

    this.startActivity(intent)

  end

end

local onItemClick = function(view,views,key,data)

  if data.url

    openInBrowser(data.url)

   elseif key=="qq"

    pcall(this.startActivity,Intent(Intent.ACTION_VIEW,Uri.parse("mqqapi://card/show_pslcard?uin=" .. data.qq)))

   elseif key=="qq_group"

    pcall(this.startActivity,Intent(Intent.ACTION_VIEW, Uri.parse(("mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%s&card_type=group&source=qrcode"):format(data.groupId))))

   elseif key=="openSourceLicenses"

    ActivityUtil.new("OpenSourceLicense")

   elseif key=="html"

    ActivityUtil.new("HtmlFileViewer",{ {title = data.title, path = data.path } })

   elseif key=="thanks"

    local items = {}

    for index, content pairs(data.thanks)

      if bindClass "android.os.Build".VERSION.SDK_INT >= 28

        local text1 = SpannableString(index)
        local text2 = SpannableString(content)

        text1.setSpan(ForegroundColorSpan(Colors.colorPrimary), 0, utf8.len(index), Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
        text1.setSpan(TypefaceSpan(Typeface_TTF(2)), 0, utf8.len(index), Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
        text2.setSpan(ForegroundColorSpan(Colors.colorOnSurfaceVariant), 0, utf8.len(content), Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
        text2.setSpan(TypefaceSpan(Typeface_TTF()), 0, utf8.len(content), Spannable.SPAN_EXCLUSIVE_INCLUSIVE)

        local combinedText = SpannableStringBuilder().append(text1).append("：").append(text2)



        table.insert(items, setFontSize(combinedText, TextSize ))

       else

        table.insert(items, index .. "：" .. content)

      end

    end

    MaterialAlertDialog(this)
    .setTitle(res.string.thanksList)
    .setItems(items)
    .setPositiveButton(res.string.ok)
    .show()

   elseif key == "update"

    --UpdateUtil.getCheck(true)

  end
end

local data = {
  {
    SettingsLayUtil.TITLE,
    title = res.string.about_title,
  },
  {
    SettingsLayUtil.ITEM,
    title = res.string.nowversion_app,
    summary = ("%s(%s)"):format(PackInfo.versionName,PackInfo.versionCode),
    icon = "ic_information_outline",
    key = "update",
  };
  {
    SettingsLayUtil.ITEM,
    title = res.string.pluginsutil_version,
    summary = PluginsUtil._VERSION,
    icon = "ic_puzzle_outline",
  },
  {
    SettingsLayUtil.ITEM_NOSUMMARY,
    title = res.string.update_logs,
    url = "https://gitee.com/GitHub_W/LuaAppX/blob/master/CHANGELOG.md",
    icon = "ic_history",
    newPage = "newApp",
  },
}

local adp = SettingsLayUtil.newAdapter(data, onItemClick)
recyclerView
.setAdapter(adp)
.setLayoutManager(LinearLayoutManager())

if agreements

  local fileBasePath = activity.getLuaPath("/activities/Welcome/agreements/%s.html")

  for index,content ipairs(agreements)

    content[1] = SettingsLayUtil.ITEM_NOSUMMARY
    content.path = fileBasePath:format(content.name)
    content.key = "html"
    content.newPage = true
    table.insert(data, content)

  end
end

table.insert(data,{
  SettingsLayUtil.TITLE,
  title = res.string.developerInfo
})

for index, content ipairs({
    {
      name = "W.",
      qq = 1447017701,
      message = res.string.app_name .. " " .. res.string.developer,
    },
    {
      name = "含清蓝日",
      qq = 2241056127,
      message = res.string.project_code_optimization,
    },
    {
      name = "SMTPTX",
      qq = 3080756895,
      message = res.string.back_end_technology_provid,
    },
    {
      name = "无尘君",
      qq = 3562519024,
      message = res.string.back_end_technology_provid,
    },
  })

  table.insert(data,{
    SettingsLayUtil.ITEM_AVATAR,
    title = "@"..content.name,
    summary = content.message,
    icon = ("http://q.qlogo.cn/headimg_dl?spec=640&img_type=jpg&dst_uin=%s"):format(content.qq),
    qq = content.qq,
    key = "qq",
    newPage = "newApp",
  })

end

table.insert(data,{
  SettingsLayUtil.ITEM_NOSUMMARY,
  title = res.string.opensourcelicense,
  icon = "ic_github",
  key = "openSourceLicenses",
  newPage = true,
})

local thanks = {
  川意 = "SubtitleCollapsingToolbarLayout",
  难忘的旋律 = "luajava.so",
}

table.insert(data, {
  SettingsLayUtil.ITEM,
  title = res.string.thanksList,
  summary = res.string.ranking_random,
  icon = "ic_insert_emoticon",
  key = "thanks",
  thanks = thanks,
})

table.insert(data,{
  SettingsLayUtil.TITLE,
  title=res.string.morecontent
})

table.insert(data,{
  SettingsLayUtil.ITEM,
  title = res.string.qqgroup,
  icon = "ic_group",
  groupId = 542704713,
  summary = "542704713",
  key = "qq_group",
  newPage = "newApp",
})

table.insert(data,{
  SettingsLayUtil.ITEM,
  title = res.string.copyright,
  summary = "Copyright (c) 2024-2026, W.";
  icon = "ic_copyright",
  key = "copyright",
})