local _M = {}
local ArrayListAdapter = bindClass "android.widget.ArrayListAdapter"
local Html = bindClass "android.text.Html"
local String = bindClass "java.lang.String"
local ViewGroup = bindClass "android.view.ViewGroup"
local GridLayout = bindClass "android.widget.GridLayout"
local LinearLayout = bindClass "android.widget.LinearLayout"
local TextView = bindClass "android.widget.TextView"
local ImageView = bindClass "android.widget.ImageView"

_M.AdapterUtil = function(dialog, list, simple)

  if this.getSharedData("layouthelper_dialog") == 1

    dialog.setItems(simple)

   else

    list.setAdapter(ArrayListAdapter(this, String(simple)))

  end

end

local relative={
  "layout_above", "layout_alignBaseline", "layout_alignBottom", "layout_alignEnd", "layout_alignLeft", "layout_alignParentBottom", "layout_alignParentEnd", "layout_alignParentLeft", "layout_alignParentRight", "layout_alignParentStart", "layout_alignParentTop", "layout_alignRight", "layout_alignStart", "layout_alignTop", "layout_alignWithParentIfMissing", "layout_below", "layout_centerHorizontal", "layout_centerInParent", "layout_centerVertical", "layout_toEndOf", "layout_toLeftOf", "layout_toRightOf", "layout_toStartOf"
}

local fds_grid={
  res.string.add, res.string.delete, res.string.parent_control, res.string.child_control,
  "id", "orientation",
  "columnCount", "rowCount",
  "layout_width", "layout_height", "layout_gravity",
  "onClick","onLongClick",
  "background", "backgroundColor", "gravity",
  "visibility",
  "layout_margin", "layout_marginLeft", "layout_marginTop", "layout_marginRight", "layout_marginBottom",
  "padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
  "Rotation", "RotationX", "RotationY",
  "CardElevation", "radius"
}

local fds_linear={
  res.string.add, res.string.delete, res.string.parent_control, res.string.child_control,
  "id", "orientation", "layout_width", "layout_height", "layout_gravity",
  "onClick","onLongClick",
  "background", "backgroundColor", "gravity",
  "visibility",
  "layout_margin", "layout_marginLeft", "layout_marginTop", "layout_marginRight", "layout_marginBottom",
  "padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
  "Rotation", "RotationX", "RotationY",
  "CardElevation", "radius"
}

local fds_group={
  res.string.add, res.string.delete, res.string.parent_control, res.string.child_control,
  "id", "layout_width", "layout_height", "layout_gravity",
  "onClick","onLongClick",
  "background", "backgroundColor", "gravity",
  "visibility",
  "layout_margin", "layout_marginLeft", "layout_marginTop", "layout_marginRight", "layout_marginBottom",
  "padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
  "Rotation", "RotationX", "RotationY",
  "CardElevation", "radius"
}

local fds_text={
  res.string.delete, res.string.parent_control,
  "id", "layout_width", "layout_height", "layout_gravity",
  "onClick","onLongClick",
  "background", "backgroundColor", "text", "ellipsize",
  "hint", "textColor", "textStyle", "hintTextColor", "textSize", "singleLine", "maxLines", "maxEms", "maxHeight", "maxWidth", "minWidth", "gravity",
  "visibility",
  "layout_margin", "layout_marginLeft", "layout_marginTop", "layout_marginRight", "layout_marginBottom",
  "padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
  "Rotation", "RotationX", "RotationY",
  "CardElevation", "radius"
}

local fds_image={
  res.string.delete, res.string.parent_control,
  "id", "layout_width", "layout_height", "layout_gravity",
  "onClick","onLongClick",
  "background", "backgroundColor", "src", "scaleType", "gravity",
  "visibility",
  "layout_margin", "layout_marginLeft", "layout_marginTop", "layout_marginRight", "layout_marginBottom",
  "padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
  "Rotation", "RotationX", "RotationY", "ColorFilter";
  "CardElevation", "radius"
}

local fds_view={
  res.string.delete, res.string.parent_control,
  "id", "layout_width", "layout_height", "layout_gravity",
  "onClick","onLongClick",
  "background", "gravity",
  "layout_margin", "layout_marginLeft", "layout_marginTop", "layout_marginRight", "layout_marginBottom",
  "padding", "paddingLeft", "paddingTop", "paddingRight", "paddingBottom",
  "Rotation", "RotationX", "RotationY", "StrokeWidth", "StrokeColor",
  "CardElevation", "radius"
}

ns={
  "Widget (小部件)", "Check view (检查视图)", "Adapter view (适配器视图)",
  "Advanced Widget (高级部件)", "Layout (布局)", "Advanced Layout (高级布局)",
  "Material Design (质感设计)", "Other Widget (其他控件)"
}

wds={
  {"AppCompatButton", "AppCompatEditText", "AppCompatTextView",
    "AppCompatImageButton", "AppCompatImageView", "CircleImageView"},
  {"AppCompatCheckBox", "AppCompatRadioButton", "AppCompatToggleButton",
    "SwitchMaterial"},
  {"ListView", "ViewPager", "ExpandableListView", "ScrollGridView",
    "ScrollListView", "ExpandableListView", "AppCompatSpinner", "RecyclerView"},
  {"SeekBar", "ProgressBar", "RatingBar",
    "DatePicker", "TimePicker", "NumberPicker", "LuaEditor", "LuaWebView"},
  {"LinearLayout", "LinearLayoutCompat", "AbsoluteLayout",
    "FrameLayout", "RelativeLayout", "CoordinatorLayout",
    "ConstraintLayout"},
  {"CardView", "RadioGroup", "GridLayout",
    "ScrollView", "HorizontalScrollView", "NestedScrollView"}, --不兼容的布局：SwipeRefreshLayout，SlidingPaneLayout，DrawerLayout
  {"AppBarLayout",
    "BottomAppBar", "BottomNavigationView", "BottomNavigationItemView",
    "CircularRevealGridLayout", "CircularRevealFrameLayout", "CircularProgressIndicator", "Chip", "ChipGroup", "CollapsingToolbarLayout", "SubtitleCollapsingToolbarLayout",
    "MaterialButton", "MaterialTextView", "MaterialTextField",
    "MaterialCardView", "MaterialSwitch", "MaterialCheckBox", "MaterialDivider",
    "NavigationView",
    "TabLayout", "TextInputLayout", "TextInputEditText",
    "FloatingActionButton", "ExtendedFloatingActionButton",
    "SearchBar", "Slider", },
  {"MarText", "AutoCompleteTextView", "SearchView",
    "PullingLayout", "HorizontalListView", "RippleLayout", "TextClock", "PhotoView",
    "StackView", "SurfaceView", "View", "SwipeMenuListView"}
}

local getSpannableString = function(key, str)

  if bindClass "android.os.Build".VERSION.SDK_INT >= 28

    local Spannable = bindClass "android.text.Spannable"
    local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
    local SpannableString = bindClass "android.text.SpannableString"
    local Spanned = bindClass "android.text.Spanned"
    local TypefaceSpan = bindClass "android.text.style.TypefaceSpan"
    local Typeface = bindClass "android.graphics.Typeface"

    local s = key.." = " .. tostring(str)
    local start_len = utf8.len(key.." = ")
    local end_len = utf8.len(s)
    local spanned = Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
    local spannableString = SpannableString(s)

    spannableString.setSpan(ForegroundColorSpan(Colors.colorPrimary), start_len, end_len, spanned)
    spannableString.setSpan(TypefaceSpan(Typeface_TTF(2)), start_len, end_len, spanned)

    return spannableString

   else
   
   return key .. " = " .. tostring(str)

  end



end

_M.getCurr = function(v)

  curr = v.Tag
  currView = v

  setTitle(fd_dlg, fd_title, tostring(v.Class.getSimpleName()))

  local adapter = function(SimpleName)

    if this.getSharedData("layouthelper_dialog") == 1

      fd_dlg.setItems(SimpleName)

     else

      fd_list.setAdapter(ArrayListAdapter(this, String(SimpleName)))

    end

  end

  if luajava.instanceof(v, GridLayout)

    adapter(fds_grid)

   elseif luajava.instanceof(v, LinearLayout)

    adapter(fds_linear)

   elseif luajava.instanceof(v, ViewGroup)

    adapter(fds_group)

   elseif luajava.instanceof(v, TextView)

    adapter(fds_text)

   elseif luajava.instanceof(v, ImageView)

    adapter(fds_image)

   else

    adapter(fds_view)

  end

  if luajava.instanceof(v.Parent, LinearLayout) or luajava.instanceof(v.Parent, LinearLayoutCompat)

    fd_list.getAdapter().add("layout_weight")

   elseif luajava.instanceof(v.Parent, AbsoluteLayout)

    fd_list.getAdapter().insert(5, "layout_x")
    fd_list.getAdapter().insert(6, "layout_y")

   elseif luajava.instanceof(v.Parent, RelativeLayout)

    local adp = fd_list.getAdapter()

    for k, v ipairs(relative)

      adp.add(v)

    end

  end

  local adapter = fd_list.adapter
  local put_position = 4
  local unknow_fd = table.clone(curr)

  for k, v pairs(unknow_fd)

    if tonumber(k)

      unknow_fd[k] = 0

    end

  end

  for i = 0, adapter.count - 1

    local key = adapter.getItem(i)

    if key == "id"

      put_position = i

    end

    if curr[key]

      adapter.remove(i)
      adapter.insert(put_position, getSpannableString(key, curr[key]))
      unknow_fd[key] = nil

    end

  end

  for k, v pairs(unknow_fd)

    if not tonumber(k)

      adapter.insert(put_position, getSpannableString(k, v))

    end
  end

  fd_dlg.show()

end

return _M