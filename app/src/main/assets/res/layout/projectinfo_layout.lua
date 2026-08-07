local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local CollapsingToolbarLayout = bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local FloatingActionButton = bindClass "com.google.android.material.floatingactionbutton.FloatingActionButton"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialSwitchBar = bindClass "concerrox.ripple.switches.MaterialSwitchBar"
local MaterialButton = bindClass "com.google.android.material.button.MaterialButton"
local TextInputView = require "mods.view.TextInputView"

return {
  CoordinatorLayout,
  w="fill",
  h="fill",
  {
    AppBarLayout,
    w="fill",
    {
      CollapsingToolbarLayout,
      w="fill",
      h="160dp",
      CollapsedTitleTextSize=dp2px(TextSize + 8),
      CollapsedTitleTypeface=Typeface_TTF(),
      ExpandedTitleTextSize=dp2px(TextSize + 12),
      ExpandedTitleTypeface=Typeface_TTF(),
      layout_scrollFlags=3,
      backgroundColor=Colors.colorBackground,
      {
        MaterialToolbar,
        backgroundColor=Colors.colorBackground,
        layout_collapseMode="pin",
        h="64dp",
        w="fill",
        id="toolbar",
      },
    },
  },
  {
    NestedScrollView,
    h="fill",
    w="fill",
    layout_behavior="appbar_scrolling_view_behavior",
    {
      LinearLayoutCompat,
      h="fill",
      w="fill",
      orientation="vertical",
      layoutTransition=mTransition,
      {
        LinearLayoutCompat,
        h="70dp",
        w="70dp",
        layout_marginTop=0,
        layout_margin="12dp",
        layout_marginBottom=0,
        gravity="center",
        {
          MaterialCardView,
          id="icon2",
          h="fill",
          w="fill",
          layout_margin="6dp",
          CardBackgroundColor=0,
          StrokeColor=Colors.colorSurfaceVariant,
          {
            AppCompatImageView,
            id="icon",
            h="fill",
            w="fill",
            scaleType="centerCrop",
            src="icon.png",
            layout_margin="-8dp",
          }
        }
      },
      {
        TextInputView.TextInputLayout,
        Hint=res.string.name,
        layout_margin="20dp",
        layout_marginTop="14dp",
        layout_marginBottom=0,
        w="fill",
        id="project_name2",
        {
          TextInputView.TextInputEditText,
          w="fill",
          singleLine=true,
          id="project_name",
        },
      },
      {
        TextInputView.TextInputLayout,
        Hint=res.string.package,
        layout_margin="20dp",
        layout_marginTop="14dp",
        layout_marginBottom=0,
        w="fill",
        id="project_package2",
        {
          TextInputView.TextInputEditText,
          w="fill",
          singleLine=true,
          id="project_package",
        },
      },
      {
        LinearLayoutCompat,
        w="fill",
        {
          TextInputView.TextInputLayout,
          Hint=res.string.appver,
          layout_margin="20dp",
          layout_marginRight="10dp",
          layout_marginTop="14dp",
          layout_marginBottom=0,
          w="fill",
          layout_weight=1,
          id="project_appver2",
          {
            TextInputView.TextInputEditText,
            w="fill",
            singleLine=true,
            id="project_appver",
          },
        },
        {
          TextInputView.TextInputLayout,
          Hint=res.string.appcode,
          layout_margin="20dp",
          layout_marginLeft="10dp",
          layout_marginTop="14dp",
          layout_marginBottom=0,
          w="fill",
          layout_weight=1,
          id="project_appcode2",
          {
            TextInputView.TextInputEditText,
            w="fill",
            singleLine=true,
            id="project_appcode",
          },
        },
      },
      {
        TextInputView.TextInputLayout,
        Hint="SDK(" .. res.string.min .. "/" .. res.string.target .. ")",
        layout_margin="20dp",
        layout_marginTop="14dp",
        layout_marginBottom=0,
        w="fill",
        id="project_sdk2",
        {
          TextInputView.TextInputEditText,
          w="fill",
          singleLine=true,
          id="project_sdk",
        },
      },
      {
        MaterialSwitchBar,
        w="fill",
        id="debugmode2",
        text=setFontSize(res.string.debugmode, TextSize + 1),
        layout_margin="20dp",
        layout_marginBottom=0,
      },
      {
        MaterialButton,
        textSize=TextSize,
        text=res.string.change_permission,
        Typeface=Typeface_TTF(),
        layout_width="fill",
        layout_margin="20dp",
        id="btn",
      }
    }
  },
  {
    FloatingActionButton,
    id="fab",
    layout_margin="16dp",
    layout_gravity="end|bottom",
    ImageDrawable=res.drawable.ic_check
  },
}