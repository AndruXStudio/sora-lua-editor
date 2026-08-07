local bindClass = luajava.bindClass
local Gravity = bindClass "android.view.Gravity"
local Snackbar = bindClass "com.google.android.material.snackbar.Snackbar"
local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local MaterialCardView = bindClass "com.google.android.material.card.MaterialCardView"
local NestedScrollView = bindClass "androidx.core.widget.NestedScrollView"
local AppCompatTextView = bindClass "androidx.appcompat.widget.AppCompatTextView"

return function(...)

  local buf = {}
  for n = 1, select("#", ...) do
    table.insert(buf, tostring(select(n, ...)))
  end
  local str = table.concat(buf, "\t\t")
  local anchor = activity.findViewById(android.R.id.content)
  local mSnackbar = Snackbar.make(anchor, "" ,Snackbar.LENGTH_LONG)
  local snackbarView = mSnackbar.getView()

  snackbarView.addView(Layout.inflate({
    LinearLayoutCompat,
    w="fill",
    h="fill",
    gravity="center",
    {
      MaterialCardView,
      CardBackgroundColor=Colors.colorPrimary,
      CardElevation="2dp",
      layout_margin="16dp",
      {
        NestedScrollView,
        w="fill",
        h="fill",
        overScrollMode="2",
        VerticalScrollBarEnabled=false,
        {
          AppCompatTextView,
          textColor=Colors.colorBackground,
          textSize=TextSize,
          text=TypefaceString(tostring(str)),
          ellipsize="end",
          textIsSelectable=true,
          layout_margin="12dp",
          id="toast_text",
        },
      },
    },
  }))

  snackbarView.setBackgroundColor(0)

  local params = snackbarView.getLayoutParams()
  params.width = -2
  params.setMargins(0,180,0,210)
  params.gravity = Gravity.CENTER | Gravity.BOTTOM
  snackbarView.setLayoutParams(params)

  return mSnackbar.show()

end