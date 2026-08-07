-- Author:含清蓝日

local ContainerViewClass = "androidx.fragment.app.FragmentContainerView"
local FragmentContainerView = bindClass (ContainerViewClass)
local LuaFragment = bindClass "com.androlua.LuaFragment"
local ViewGroup = bindClass "android.view.ViewGroup"
local MaterialSharedAxis = bindClass "com.google.android.material.transition.MaterialSharedAxis"
local TransitionManager = bindClass "androidx.transition.TransitionManager"

local mContainer,mId
local currentIndex = 1
local Fragments = {}
local Views = {}

local fragmentManager = this.getSupportFragmentManager()
local fragmentTransaction = fragmentManager.beginTransaction()

local _M = {}

_M.addFragment = function(layout)
  
  local t = type(layout)
  
  if t=="table" then
    layout = loadlayout(layout)
   elseif not luajava.instanceof(layout,ViewGroup)
    error("ViewGroup expected,got "..t)
  end

  table.insert(Views,layout)
  table.insert(Fragments,
  LuaFragment().setLayout(layout)
  )

  return _M
  
end

_M.commitFragment = function()

  for k,v ipairs(Fragments) do
    fragmentTransaction.add(mId,v)
  end

  fragmentTransaction.commit()

  for k,v in ipairs(Fragments) do
    if k !=1 then
      fragmentTransaction.hide(v)
    end
  end

  return _M
end

_M.showFragment = function(index)
 
  index = index + 1
  
  if index == currentIndex then
    return true
  end

  local currentFragment = Fragments[currentIndex]
  local nextFragment = Fragments[index]

  fragmentManager
  .beginTransaction()
  .setCustomAnimations(
  MDC_R.anim.m3_bottom_sheet_slide_in,
  MDC_R.anim.m3_bottom_sheet_slide_out)
  .show(nextFragment)
  .hide(currentFragment)
  .commit()
  currentIndex = index

  return _M
end

_M.hideFragment = function()

  fragmentTransaction.hide(Fragments[currentIndex])

  return _M
end

_M.getCurrentltem =function()

  return currentIndex

end

return setmetatable({},{

  __call = function(self,fragmentcontainer)

    local t = type(fragmentcontainer)

    if t != "userdata" then
      error(ContainerViewClass.." expected, got "..t)
     elseif not luajava.instanceof(fragmentcontainer,FragmentContainerView) then
      error(ContainerViewClass.." expected, got "..tostring(fragmentcontainer))
    end

    mContainer = fragmentcontainer
    mId = fragmentcontainer.getId()

    return _M

  end,
})