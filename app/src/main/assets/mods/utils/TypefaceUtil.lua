TextSize = tonumber(this.getSharedData("global_font_size") + 12)

function Typeface_TTF(type)

  if type == 1 or type == nil

    return res.font.Google_Sans_Mono_Regular

   elseif type == 2

    return res.font.RobotoMono_Bold

   elseif type == 3

    return res.font.Kosefin_Sans

   elseif type == 4

    return res.font.JetBrains_Mono

  end

end

if bindClass "android.os.Build".VERSION.SDK_INT >= 28

  local Typeface = bindClass "android.graphics.Typeface"
  local Spannable = bindClass "android.text.Spannable"
  local SpannableString = bindClass "android.text.SpannableString"
  local TypefaceSpan = bindClass "android.text.style.TypefaceSpan"
  local AbsoluteSizeSpan = bindClass "android.text.style.AbsoluteSizeSpan"

  function TypefaceString(str,type)

    local string = SpannableString(str)
    string.setSpan(TypefaceSpan(Typeface_TTF(type)), 0, #string,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
    return string

  end

  function setFontSize(text, sizeInPx)

    local spannableString = SpannableString(text)
    local sizeSpan = AbsoluteSizeSpan(dp2px(sizeInPx))
    spannableString.setSpan(sizeSpan, 0, spannableString.length(), 0)
    return spannableString

  end

 else

  function TypefaceString(str,type)
    return str
  end

  function setFontSize(text, sizeInPx)
    return text
  end

end