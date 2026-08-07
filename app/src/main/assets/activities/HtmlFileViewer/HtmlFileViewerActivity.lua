require "environment"
local EditorMovementMethodUtil = bindClass "com.load.LuaAppX.utils.MovementMethodUtil"
local Html = bindClass "android.text.Html"

local data = ...

this {
  Title = res.string.htmlfileviewer,
  ContentView = res.view.htmlfileviewer_layout,
  SupportActionBar = toolbar
}
.getSupportActionBar()
{
  DisplayHomeAsUpEnabled = true
}

onOptionsItemSelected = function(item)

  if item.getItemId() == android.R.id.home

    finish()

  end

end

textView.setLinksClickable(true)
textView.setMovementMethod(EditorMovementMethodUtil.getInstance())
textView.requestFocusFromTouch()

if data.title

  this.getSupportActionBar().setTitle(data.title)

end

local path = data.path
local url = data.url

if path

  local content=io.open(path):read("*a")

  if tostring(data.text) == "true"

    textView.setText(content)

   else

    textView.setText(Html.fromHtml(content))

  end
end