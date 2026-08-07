local _M = {}
local DialogInterface = bindClass "android.content.DialogInterface"
local Dialog = bindClass "android.app.Dialog"
local View = bindClass "android.view.View"

function _M.onShow(id,callback)

  id.setOnShowListener(DialogInterface.OnShowListener{
    onShow = function(dialog)
    
      id.getButton(Dialog.BUTTON_POSITIVE).setOnClickListener(View.OnClickListener
      {
        onClick=function()
          callback()
        end
      })
      
    end
  })
  
end

return _M