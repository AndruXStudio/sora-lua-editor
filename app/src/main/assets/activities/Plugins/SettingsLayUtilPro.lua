local SettingsLayUtil = require "mods.utils.SettingsLayUtil"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local itemsLay = SettingsLayUtil.itemsLay
local oldLastIndex = SettingsLayUtil.itemsNumber

SettingsLayUtil.ITEM_AVATAR_SWITCH = oldLastIndex+1
SettingsLayUtil.ITEM_AVATAR_ICON_SWITCH = oldLastIndex+2
SettingsLayUtil.itemsNumber = oldLastIndex+2

local infoLay = {
  AppCompatImageView,
  padding="8dp",
  id="infoBtnView",
  layout_width="40dp",
  layout_height="48dp",
  ImageDrawable=res.drawable.ic_information_outline,
}

table.insert(itemsLay, {
  LinearLayoutCompat,
  layout_width="fill",
  gravity="center",
  focusable=true,
  SettingsLayUtil.leftCoverLay,
  SettingsLayUtil.twoLineLay,
  infoLay,
  SettingsLayUtil.rightSwitchLay,
})

table.insert(itemsLay, {
  LinearLayoutCompat,
  layout_width="fill",
  gravity="center",
  focusable=true,
  SettingsLayUtil.leftCoverIconLay,
  SettingsLayUtil.twoLineLay,
  infoLay,
  SettingsLayUtil.rightSwitchLay,
})