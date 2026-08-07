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
          LinearLayoutCompat,
          h="75dp",
          w="75dp",
          gravity="center",
          padding="9dp",
          {
            MaterialCardView,
            h="fill",
            w="fill",
            CardBackgroundColor=0,
            StrokeColor=Colors.colorSurfaceVariant,
            {
              AppCompatImageView,
              id="icon2",
              h="fill",
              w="fill",
              Visibility=(function() if this.getSharedData("show_item_icon") return 0 else return 8 end end)(),
              scaleType="centerCrop",
              layout_margin="-8dp",
            },
            {
              AppCompatTextView,
              backgroundColor=Colors.colorPrimary,
              textColor=0xFFFFFFFF,
              textSize=TextSize + 10,
              Typeface=Typeface_TTF(),
              gravity="center",
              h="fill",
              Visibility=(function() if this.getSharedData("show_item_icon") return 8 else return 0 end end)(),
              w="fill",
              id="icon3"
            }
          }
        },
        {
          AppCompatTextView,
          id="appname2",
          gravity="center",
          layout_marginBottom="2dp",
          textSize=TextSize + 5,
          Typeface=Typeface_TTF(2),
          textColor=Colors.colorOnBackground,
        },
        {
          AppCompatTextView,
          id="packagename2",
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
          id="build",
          w="25%w",
          layout_weight=1,
          text=res.string.build,
          Color=Colors.colorPrimary,
          backgroundDrawable=ColorUtil.getRipple(),
          Icon=res.drawable.ic_package_variant,
        },
        {
          HeroButton,
          Color=Colors.colorPrimary,
          w="25%w",
          id="backup",
          layout_weight=1,
          text=res.string.backup,
          backgroundDrawable=ColorUtil.getRipple(),
          Icon=res.drawable.ic_zip_box_outline,
        },
        {
          HeroButton,
          id="share",
          w="25%w",
          Color=Colors.colorPrimary,
          layout_weight=1,
          text=res.string.share,
          backgroundDrawable=ColorUtil.getRipple(),
          Icon=res.drawable.ic_share_variant_outline,
        },
        {
          HeroButton,
          layout_weight=1,
          w="25%w",
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
        h="wrap",
        Title="Version",
        id="prefVersion",
        Icon=res.drawable.ic_clock_outline,
        IconColor=Colors.colorOutline,
      },
      {
        Preference,
        w="fill",
        h="wrap",
        Title="SDK",
        id="prefSdk",
        Icon=res.drawable.ic_greater_than_or_equal,
        IconColor=Colors.colorOutline,
      },
      {
        Preference,
        w="fill",
        h="wrap",
        Title="Permission",
        id="perfPermission",
        Icon=res.drawable.ic_account_key_outline,
        IconColor=Colors.colorOutline,
      },
      {
        Preference,
        w="fill",
        h="wrap",
        Title="Project Path",
        id="perfPath",
        Icon=res.drawable.ic_folder_outline,
        IconColor=Colors.colorOutline,
      },
    }
  }
}