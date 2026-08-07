import "com.airbnb.lottie.LottieDrawable"
import "com.airbnb.lottie.LottieCompositionFactory"
import "com.airbnb.lottie.model.KeyPath"
import "com.airbnb.lottie.LottieProperty"
import "com.airbnb.lottie.value.SimpleLottieValueCallback"
import "com.airbnb.lottie.SimpleColorFilter"
import "java.io.FileInputStream"
import "modules.class"

return class {
  extends = LottieDrawable,
  constructor = function(super, path, color)
    local composition = LottieCompositionFactory.fromJsonInputStreamSync(
      FileInputStream(this.luaDir.."/res/lottie/"..path..".json"), nil) 
    
    local obj = super()
    obj.setComposition(composition.value)     
    if color then
      obj.addValueCallback(
        KeyPath { "**" },
        LottieProperty.COLOR_FILTER,
        SimpleLottieValueCallback {
          function getValue()
            return SimpleColorFilter(color)
          end
        }
      )
    end
    return obj
  end,
  
  methods = {
    function setColor(self, color)
      --print(self, color)
      self.addValueCallback(
        KeyPath { "**" },
        LottieProperty.COLOR_FILTER,
        SimpleLottieValueCallback {
          function getValue()
            return SimpleColorFilter(color)
          end
        }
      )
      return self
    end,
  }
}