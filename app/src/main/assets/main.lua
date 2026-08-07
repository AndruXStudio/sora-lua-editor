require "mods.utils.InitAppUtil"
require "environment"

local ActivityUtil = require "mods.utils.ActivityUtil"
local agreements = require "activities.Welcome.WelcomeActivity$data"

local welcomeAgain = not(this.getSharedData("welcome"))

if not(welcomeAgain) then

  for index=1, #agreements

    local content=agreements[index]

    if this.getSharedData(content.name) ~= content.date then

      welcomeAgain = true
      this.setSharedData("welcome", false)
      break

    end

  end

end

if welcomeAgain

  ActivityUtil.new("Welcome")

 else

  ActivityUtil.new("Main")
  
end

finish()