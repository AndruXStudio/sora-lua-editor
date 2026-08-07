local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local BottomSheetDragHandleView = bindClass "com.google.android.material.bottomsheet.BottomSheetDragHandleView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local MaterialDivider = bindClass "com.google.android.material.divider.MaterialDivider"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"
local HeroButtonGroup = require "mods.view.HeroButtonGroup"
local HeroButton = require "mods.view.HeroButton"
local Preference = require "mods.view.Preference"
local ColorUtil = require "mods.utils.ColorUtil"

return {
  LinearLayoutCompat,
  w="fill",
  h="fill",
  orientation="vertical",
  {
    BottomSheetDragHandleView,
    w="fill",
  },
  {
    NestedScrollView,
    w="fill",
    h="fill",
    {
      LinearLayoutCompat,
      w="fill",
      h="fill",
      orientation="vertical",
      {
        LinearLayoutCompat,
        layout_marginLeft="22dp",
        layout_marginRight="22dp",
        orientation="vertical",
        gravity="center",
        w="fill",
        {
          AppCompatTextView,
          id="foldername",
          gravity="center",
          layout_marginBottom="2dp",
          textSize=TextSize + 5,
          Typeface=Typeface_TTF(2),
          textColor=Colors.colorOnBackground,
        },
        {
          AppCompatTextView,
          id="time",
          layout_marginTop="2dp",
          ellipsize="middle",
          MaxLines=1,
          gravity="center",
          textSize=TextSize + 1.5,
          Typeface=Typeface_TTF(),
          textColor=Colors.colorOutline,
        },
      },
      {
        HeroButtonGroup,
        w="fill",
        layout_marginTop="16dp",
        {
          HeroButton,
          id="rename",
          w="25%w",
          layout_weight=1,
          text=res.string.rename,
          Color=Colors.colorPrimary,
          backgroundDrawable=ColorUtil.getRipple(),
          Icon=res.drawable.ic_drive_file_rename_outline,
        },
        {
          HeroButton,
          id="createfile",
          Color=Colors.colorPrimary,
          w="25%w",
          layout_weight=1,
          text=res.string.file .. "(" .. res.string.son .. ")",
          backgroundDrawable=ColorUtil.getRipple(),
          Icon=res.drawable.ic_file_create_outline,
        },
        {
          HeroButton,
          id="createdir",
          w="25%w",
          Color=Colors.colorPrimary,
          layout_weight=1,
          text=res.string.folder .. "(" .. res.string.son .. ")",
          backgroundDrawable=ColorUtil.getRipple(),
          Icon=res.drawable.ic_create_new_folder,
        },
        {
          HeroButton,
          w="25%w",
          layout_weight=1,
          Color=Colors.colorError,
          text=res.string.delete,
          id="delete",
          backgroundDrawable=ColorUtil.getRipple(false, 0x31FF0000),
          Icon=res.drawable.ic_delete_forever_outline,
        }
      },
      {
        MaterialDivider,
        layout_marginBottom="8dp",
      },
      {
        Preference,
        w="fill",
        Title="Size",
        id="prefSize",
        Icon=res.drawable.ic_database_outline,
        IconColor=Colors.colorOutline,
      },
      {
        Preference,
        w="fill",
        Title="Folder Path",
        id="perfPath",
        Icon=res.drawable.ic_folder_outline,
        IconColor=Colors.colorOutline,
      },
    }
  }
}