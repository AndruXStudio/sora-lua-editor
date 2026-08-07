local Build = bindClass "android.os.Build"
local SettingsLayUtil = require "mods.utils.SettingsLayUtil"
local packageInfo = this.getPackageManager().getPackageInfo(this.getPackageName(),0)

return
{

  {
    SettingsLayUtil.TITLE,
    title = res.string.ui,
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_palette_outline",
    title = res.string.theme_color,
    key = "theme_color",
    items = {
      res.string.theme_blue,
      res.string.theme_green,
      res.string.theme_red,
      res.string.theme_orange,
      res.string.theme_pink,
      res.string.theme_purple,
      res.string.theme_brown
    },
  },
  {
    SettingsLayUtil.ITEM_SWITCH,
    icon = "ic_eyedropper_variant",
    title = res.string.dynamic_color_extraction,
    key = "eyedropper_variant",
    summary = res.string.dynamic_color_extraction_tip,
    enabled = (function() if Build.VERSION.SDK_INT >= 31 return true else return false end end)(),
    switchEnabled = (function() if Build.VERSION.SDK_INT >= 31 return true else return false end end)(),
  },
  {
    SettingsLayUtil.ITEM_SWITCH,
    icon = "ic_blur",
    title = res.string.dialog_box_blur,
    key = "dialog_box_blur",
    summary = res.string.dialog_box_blur_tip,
    enabled = (function() if Build.VERSION.SDK_INT > 31 return true else return false end end)(),
    switchEnabled = (function() if Build.VERSION.SDK_INT > 31 return true else return false end end)(),
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_theme_light_dark",
    title = res.string.theme_light_dark,
    key = "theme_light_dark",
    items = {
      res.string.lollower_system,
      res.string.always_on,
      res.string.always_closed,
    },
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_format_size",
    title = res.string.global_font_size,
    key = "global_font_size",
    items = {
      "13",
      "14",
      "15",
    },
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_view_dashboard_outline",
    title = res.string.item_list_columns,
    key = "item_list_columns",
    items = {
      "1",
      "2",
    },
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY;
    icon = "ic_image_outline",
    title = res.string.show_item_icon,
    key = "show_item_icon",
  },
  {
    SettingsLayUtil.TIME_SWITCH_NOICON,
    title = res.string.slide_hide,
    summary = res.string.slide_hide_tip,
    key = "slide_hide",
  },

  {
    SettingsLayUtil.TITLE,
    title = res.string.pack,
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY;
    icon = "ic_shield_lock_outline",
    title = res.string.compileLua,
    key = "compileLua",
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_key",
    title = res.string.signature_scheme,
    key = "signature_scheme",
    items = {
      "V1",
      "V1 + V2",
      "V1 + V2 + V3",
    },
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_android",
    title = res.string.automatic_installation,
    key = "automatic_installation",
  },

  {
    SettingsLayUtil.TITLE,
    title = res.string.plugins,
  };
  {
    SettingsLayUtil.ITEM_NOSUMMARY,
    icon = "ic_puzzle_outline",
    title = res.string.plugins_title,
    key = "plugins_manager",
    newPage = true,
  },

  {
    SettingsLayUtil.TITLE,
    title = res.string.editor_qi,
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_content_save_outline",
    title = res.string.code_save_exception_detection,
    key = "code_save_exception_detection",
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_brightness_4",
    title = res.string.dark_toolbar,
    key = "dark_toolbar",
  },
  {
    SettingsLayUtil.ITEM_SWITCH,
    icon = "ic_format_line_spacing_black",
    title = res.string.editor_showblankchars,
    key = "editor_showBlankChars",
    summary = res.string.editor_showblankchars_tip,
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_wrap_text",
    title = res.string.editor_wordwrap,
    key = "editor_wordwrap",
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_iframe_outline",
    title = res.string.editor_completing_box,
    key="editor_completing_box",
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_bug_outline",
    title = res.string.editor_code_parser,
    key = "editor_code_parser",
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_warning",
    title = res.string.runtime_check_code,
    key = "check_error",
  },
  {
    SettingsLayUtil.ITEM_SWITCH,
    icon = "ic_magnify_plus_outline",
    title = res.string.code_magnifier,
    summary = res.string.code_magnifier_tip,
    key = "editor_magnify",
    enabled = (function() if Build.VERSION.SDK_INT > 28 return true else return false end end)(),
    switchEnabled = (function() if Build.VERSION.SDK_INT > 28 return true else return false end end)(),
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_symbol",
    title=res.string.symbol_bar,
    key = "editor_symbolBar",
  },
  {
    SettingsLayUtil.ITEM;
    icon = "ic_symbol",
    title = res.string.custom_symbol_bar,
    action = "custom_symbol_bar",
    enabled = (function() if this.getSharedData("editor_symbolBar") return true else return false end end)(),
  },
  {
    SettingsLayUtil.TIEM_CARD,
    icon = "ic_palette_outline",
    title = res.string.keyword_color,
    action = "keyword_color",
  },
  {
    SettingsLayUtil.TIEM_CARD,
    icon = "ic_palette_outline",
    title = res.string.userword_color,
    action = "userword_color",
  },
  {
    SettingsLayUtil.TIEM_CARD,
    icon = "ic_palette_outline",
    title = res.string.baseword_color,
    action = "baseword_color",
  },
  {
    SettingsLayUtil.TIEM_CARD,
    icon = "ic_palette_outline",
    title = res.string.string_color,
    action = "string_color",
  },
  {
    SettingsLayUtil.TIEM_CARD,
    icon = "ic_palette_outline",
    title = res.string.comment_color,
    action = "comment_color",
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_lightbulb_on_outline",
    title=res.string.custom_syntax_highlighting,
    action = "custom_syntax_highlighting",
  },

  {
    SettingsLayUtil.TITLE,
    title = res.string.layout_helper,
  },
  {
    SettingsLayUtil.ITEM_SWITCH_NOSUMMARY,
    icon = "ic_delete_forever_outline",
    title=res.string.c_when_deleting_control,
    key = "deleting_control",
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_window_maximize",
    title = res.string.layouthelper_dialog,
    key = "layouthelper_dialog",
    items = {
      "MaterialAlertDialogBuilder",
      "BottomSheetDialog"
    },
  },

  {
    SettingsLayUtil.TITLE,
    title = res.string.app,
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_delete_forever_outline",
    title = res.string.clear_data,
    summary = res.string.clear_data_tip,
    key = "clear_data",
  },
  {
    SettingsLayUtil.ITEM,
    icon = "ic_error",
    title = res.string.about_title,
    summary = res.string.nowversion_full .. "：" .. ("%s(%s)"):format(packageInfo.versionName,packageInfo.versionCode);
    key = "about",
    newPage = true,
  },

}