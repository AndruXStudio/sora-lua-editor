local _M = {}

_M.EditTextChanged = function(id,id_)

  for index,content ipairs(id)
  
    content.addTextChangedListener{
      onTextChanged = function()
      
        if content.Text ~= ""
        
          id_[index].setErrorEnabled(false)
          
        end
        
      end
    }
    
  end
end

return _M