require "environment"
local LinearLayoutManager = bindClass "androidx.recyclerview.widget.LinearLayoutManager"
local Intent = bindClass "android.content.Intent"
local Uri = bindClass "android.net.Uri"
local MaterialAlertDialog = require "mods.dialog.MaterialAlertDialog"
local SettingsLayUtil = require "mods.utils.SettingsLayUtil"
local LuaRecyclerAdapter = require "LuaRecyclerAdapter"
local data = require "activities.OpenSourceLicense.OpenSourceLicenseActivity$data"

this {
  Title = res.string.opensourcelicense,
  ContentView = res.view.setting_layout,
  SupportActionBar = toolbar
}
.getSupportActionBar()
{
  DisplayHomeAsUpEnabled = true
}

onOptionsItemSelected = function(v)

  if v.getItemId() == android.R.id.home

    finish()

  end

end

local function openInBrowser(url)
  
  local intent = Intent("android.intent.action.VIEW", Uri.parse(url))
 
  if intent.resolveActivity(this.getPackageManager())
   
    this.startActivity(intent)
    
  end

end

local adapter = LuaRecyclerAdapter(data, res.layout.opensourcelicense_item,
{
  onBindViewHolder=function(viewHolder, pos, views, currentData)

    views._data = currentData

    local name = currentData.name
    local message = currentData.message
    local license = currentData.license
    local licenseName = currentData.licenseName
    local url = currentData.url

    views.name.setText(name)

    local messageView = views.message
    local licenseView = views.license
    local cardView = views.cardView

    if message

      messageView.setText(message)
      messageView.setVisibility(0)

     else

      messageView.setVisibility(8)

    end

    if license

      licenseView.setText(licenseName or license)
      licenseView.setVisibility(0)

     else

      licenseView.setVisibility(8)

    end

    cardView.onClick = function()

      openInBrowser(url)

    end

  end,
})

recyclerView
.setAdapter(adapter)
.setLayoutManager(LinearLayoutManager())