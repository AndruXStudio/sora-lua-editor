local _M = {}
local BottomSheetDialog = bindClass "com.google.android.material.bottomsheet.BottomSheetDialog"
local BottomSheetBehavior = bindClass "com.google.android.material.bottomsheet.BottomSheetBehavior"
local DialogInterface = bindClass "android.content.DialogInterface"
local UiUtil = require "mods.utils.UiUtil"

_M.showDialog = function(layout, code)

  local mBottomSheetDialog = BottomSheetDialog(this)

  mBottomSheetDialog.window.decorView.systemUiVisibility = 2
  mBottomSheetDialog.setContentView(layout)
  .window.findViewById(MDC_R.id.design_bottom_sheet)

  if code == nil or code == true

    mBottomSheetDialog.show()

  end

  UiUtil.applyEdgeToEdgePreference(mBottomSheetDialog.getWindow())

  return mBottomSheetDialog

end

_M.prepareListView = function(id)

  return id.setDividerHeight(0).setFastScrollEnabled(false).setVerticalScrollBarEnabled(false).setHorizontalScrollBarEnabled(false).setOverScrollMode(2)

end

return _M