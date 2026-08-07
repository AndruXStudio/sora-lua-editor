local _M = {}
local Glide = bindClass "com.bumptech.glide.Glide"
local DrawableTransitionOptions = bindClass "com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions"

_M.clear = function(v)

  return Glide.with(activity).clear(v)

end

_M.setImage = function(path, view)

  Glide.get(this).clearMemory()
  
  Glide.with(this).load(path).transition(DrawableTransitionOptions.withCrossFade()).into(view)
  
  return _M

end

return _M