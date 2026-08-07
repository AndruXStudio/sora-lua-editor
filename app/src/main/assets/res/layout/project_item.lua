local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local AppCompatImageView = bindClass "androidx.appcompat.widget.AppCompatImageView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"
local ColorStateList = bindClass "android.content.res.ColorStateList"

return (function()

  if ProjectListMode == 1

    return {
      LinearLayoutCompat,
      w="fill",
      paddingTop="8dp",
      paddingBottom="8dp",
      {
        MaterialCardView,
        clickable=true,
        RippleColor=ColorStateList.valueOf(colorRipple),
        StrokeColor=Colors.colorSurfaceVariant,
        w="fill",
        id="card",
        {
          LinearLayoutCompat,
          w="fill",
          h="65dp",
          {
            LinearLayoutCompat,
            h="65dp",
            w="65dp",
            gravity="center",
            {
              MaterialCardView,
              h="fill",
              w="fill",
              layout_margin="9dp",
              CardBackgroundColor=0,
              StrokeColor=Colors.colorSurfaceVariant,
              {
                AppCompatImageView,
                id="icon",
                h="fill",
                w="fill",
                Visibility=(function() if this.getSharedData("show_item_icon") return 0 else return 8 end end)(),
                scaleType="centerCrop",
                layout_margin="-5dp",
              },
              {
                AppCompatTextView,
                backgroundColor=Colors.colorPrimary,
                textColor=0xFFFFFFFF,
                textSize=TextSize + 8,
                Typeface=Typeface_TTF(),
                gravity="center",
                Visibility=(function() if this.getSharedData("show_item_icon") return 8 else return 0 end end)(),
                h="fill",
                w="fill",
                id="icon2"
              }
            }
          },
          {
            LinearLayoutCompat,
            h="fill",
            w="fill",
            layout_marginLeft="2dp",
            layout_marginRight="16dp",
            gravity="center|left",
            orientation="vertical",
            {
              LinearLayoutCompat,
              gravity="bottom",
              layout_marginBottom="2dp",
              {
                AppCompatTextView,
                id="appname",
                layout_weight=1,
                textSize=TextSize + 0.3,
                Typeface=Typeface_TTF(),
                textColor=Colors.colorOnBackground,
              },
              {
                AppCompatTextView,
                id="appver",
                layout_marginLeft="8dp",
                textSize=TextSize - 1.5,
                Typeface=Typeface_TTF(),
                textColor=Colors.colorPrimary,
              },
            },
            {
              AppCompatTextView,
              id="packagename",
              layout_marginTop="2dp",
              ellipsize="middle",
              MaxLines=1,
              textSize=TextSize - 0.5,
              Typeface=Typeface_TTF(),
              textColor=Colors.colorOutline,
            },
          }
        }
      }
    }

   else

    return {
      LinearLayoutCompat,
      w="fill",
      paddingTop="8dp",
      paddingBottom="8dp",
      paddingLeft="8dp",
      paddingRight="8dp",
      {
        MaterialCardView,
        clickable=true,
        RippleColor=ColorStateList.valueOf(colorRipple),
        StrokeColor=Colors.colorSurfaceVariant,
        w="fill",
        id="card",
        {
          LinearLayoutCompat,
          w="fill",
          orientation="vertical",
          {
            LinearLayoutCompat,
            h="65dp",
            w="65dp",
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
                id="icon",
                h="fill",
                w="fill",
                Visibility=(function() if this.getSharedData("show_item_icon") return 0 else return 8 end end)(),
                scaleType="centerCrop",
                layout_margin="-5dp",
              },
              {
                AppCompatTextView,
                backgroundColor=Colors.colorPrimary,
                textColor=0xFFFFFFFF,
                textSize=TextSize + 8,
                Typeface=Typeface_TTF(),
                gravity="center",
                Visibility=(function() if this.getSharedData("show_item_icon") return 8 else return 0 end end)(),
                h="fill",
                w="fill",
                id="icon2"
              }
            }
          },
          {
            LinearLayoutCompat,
            layout_marginTop="2dp",
            layout_marginLeft="12dp",
            layout_marginRight="8dp",
            {
              AppCompatTextView,
              id="appname",
              layout_weight=1,
              textSize=TextSize + 0.3,
              Typeface=Typeface_TTF(2),
              textColor=Colors.colorOnBackground,
            },
            {
              AppCompatTextView,
              id="appver",
              ellipsize="end",
              MaxLines=1,
              layout_marginLeft="8dp",
              textSize=TextSize - 1.5,
              Typeface=Typeface_TTF(),
              textColor=Colors.colorPrimary,
            },
          },
          {
            AppCompatTextView,
            id="packagename",
            ellipsize="end",
            MaxLines=2,
            layout_marginTop="4dp",
            layout_margin="12dp",
            textSize=TextSize - 0.5,
            Typeface=Typeface_TTF(),
            textColor=Colors.colorOutline,
          },
        }
      }
    }

  end

end)()