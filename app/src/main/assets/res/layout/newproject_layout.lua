local CoordinatorLayout = bindClass "androidx.coordinatorlayout.widget.CoordinatorLayout"
local AppBarLayout = bindClass "com.google.android.material.appbar.AppBarLayout"
local MaterialToolbar = bindClass "com.google.android.material.appbar.MaterialToolbar"
local CollapsingToolbarLayout = bindClass "com.google.android.material.appbar.CollapsingToolbarLayout"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local FloatingActionButton = bindClass "com.google.android.material.floatingactionbutton.FloatingActionButton"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local TextInputView = require "mods.view.TextInputView"
local DrawableUtil = require "mods.utils.DrawableUtil"

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
        Hint=res.string.project_name,
        layout_margin="20dp",
        layout_marginTop="14dp",
        layout_marginBottom=0,
        w="fill",
        StartIconDrawable=DrawableUtil("ic_android",Colors.colorOnSurfaceVariant),
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
        Hint=res.string.project_package,
        layout_margin="20dp",
        layout_marginTop="14dp",
        layout_marginBottom=0,
        w="fill",
        StartIconDrawable=DrawableUtil("ic_package_variant_closed",Colors.colorOnSurfaceVariant),
        id="project_package2",
        {
          TextInputView.TextInputEditText,
          w="fill",
          singleLine=true,
          id="project_package",
        },
      },
      {
        AppCompatTextView,
        textSize=TextSize + 1,
        text="* " .. res.string.template,
        Typeface=Typeface_TTF(),
        layout_marginTop="20dp",
        layout_marginLeft="20dp",
        textColor=Colors.colorOnBackground,
      },
      {
        RecyclerView,
        h="fill",
        w="fill",
        id="recyclerView",
      },
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