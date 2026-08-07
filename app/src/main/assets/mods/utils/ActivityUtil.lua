local _M = {}

_M.new = function(name, data)

    switch name

     case "Main"

      activity.newActivity("activities/Main/MainActivity")

     case "Welcome"

      activity.newActivity("activities/Welcome/WelcomeActivity")

     case "NewProject"

      activity.newActivity("activities/NewProject/NewProjectActivity")

     case "Login"

      activity.newActivity("activities/Login/LoginActivity")

     case "Editor"

      activity.newActivity("activities/Editor/EditorActivity", data)

     case "Photo"

      activity.newActivity("activities/Photo/PhotoActivity", data)

     case "Setting"

      activity.newActivity("activities/Setting/SettingActivity")

     case "About"

      activity.newActivity("activities/About/AboutActivity")

     case "OpenSourceLicense"

      activity.newActivity("activities/OpenSourceLicense/OpenSourceLicenseActivity")

     case "HtmlFileViewer"

      activity.newActivity("activities/HtmlFileViewer/HtmlFileViewerActivity", data)

     case "ProjectInfo"

      activity.newActivity("activities/ProjectInfo/ProjectInfoActivity", data)

     case "Logs"

      activity.newActivity("activities/Logs/LogsActivity")

     case "Fix"

      activity.newActivity("activities/Fix/FixActivity", data)

     case "LayoutHelper"

      activity.newActivity("activities/LayoutHelper/LayoutHelperActivity", data)

     case "JavaApi"

      activity.newActivity("activities/JavaApi/JavaApiActivity", { data })

     case "Parsing"

      activity.newActivity("activities/Parsing/ParsingActivity", data)

     case "Plugins"

      activity.newActivity("activities/Plugins/PluginsActivity")

     case "Bin"

      activity.newActivity("activities/Bin/BinActivity", data)

    end

end

return _M