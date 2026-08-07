local _M = {}

_M.Available = false

_M.initMagnifier = function(view)
  
  Magnifier = bindClass "android.widget.Magnifier"
  
  if Magnifier.Builder
    
    _M.magnifier = Magnifier.Builder(view)
    .setSize(480, 180)
    .setCornerRadius(dp2px(6))
    .build()
    
    return
  end

end

_M.isNearChar = function(editor,relativeCaretX,relativeCaretY,x,y)
  
  local TOUCH_SLOP = editor.getTextSize()+10
  return (y >= (relativeCaretY - TOUCH_SLOP)
  and y < (relativeCaretY + TOUCH_SLOP+100)
  and x >= (relativeCaretX - TOUCH_SLOP-40)
  and x < (relativeCaretX + TOUCH_SLOP+40))
  
end

_M.show = function(view,relativeCaretX,relativeCaretY,eventX,eventY)
 
  local magnifierX=eventX
  local magnifierY=relativeCaretY-view.getTextSize()/2+2
  _M.magnifier.show(magnifierX, magnifierY);

end

_M.hide = function()
  
  pcall(function()
  _M.magnifier.dismiss()
  end)

end

return _M