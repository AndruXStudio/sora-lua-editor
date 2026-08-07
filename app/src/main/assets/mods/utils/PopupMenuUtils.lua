local _M = {}
local Typeface = bindClass "android.graphics.Typeface"
local TypefaceSpan = bindClass "android.text.style.TypefaceSpan"
local Spannable = bindClass "android.text.Spannable"
local AbsoluteSizeSpan = bindClass "android.text.style.AbsoluteSizeSpan"
local ForegroundColorSpan = bindClass "android.text.style.ForegroundColorSpan"
local SpannableString = bindClass "android.text.SpannableString"
local VERSION = bindClass "android.os.Build$VERSION"

_M.TITLE_ID = 99

_M.setHeaderTitle = function(popup, str)

  local str = SpannableString(str)
  str.setSpan(
  ForegroundColorSpan(Colors.colorPrimary),
  0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  str.setSpan(
  AbsoluteSizeSpan(dp2px(TextSize + 2)),
  0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)

  if VERSION.SDK_INT >= 29 then
    str.setSpan(
    TypefaceSpan(Typeface_TTF()),
    0, #str, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
  end

  popup.Menu.add(_M.TITLE_ID, _M.TITLE_ID, 0, str)
  popup.Menu.setGroupEnabled(_M.TITLE_ID, false)

end

return _M