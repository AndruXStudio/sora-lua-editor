local SettingsLayUtil  =  require "mods.utils.SettingsLayUtil"

return
{
  {
    SettingsLayUtil.TITLE,
    title = res.string.plugins_title,
  },
  {
    SettingsLayUtil.ITEM_NOSUMMARY,
    icon = "ic_puzzle_plus_outline",
    title = res.string.import_extension,
    key = "install_plugin",
  },
  {
    SettingsLayUtil.ITEM_NOSUMMARY,
    icon = "ic_cloud_download_outline",
    title = res.string.plugins_download,
    key = "download_plugin",
    newPage = "newApp",
  },

  {
    SettingsLayUtil.TITLE,
    title = res.string.plugins_installed,
  },
}