local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local RecyclerView = bindClass "androidx.recyclerview.widget.RecyclerView"
local SwipeRefreshLayout = bindClass "androidx.swiperefreshlayout.widget.SwipeRefreshLayout"

return {
  LinearLayoutCompat,
  h="fill",
  w="fill",
  layoutTransition=mTransition,
  {
    SwipeRefreshLayout;
    h="fill",
    w="fill",
    id="pull_project",
    (function()

      if ProjectListMode == 1

        return {
          RecyclerView,
          paddingLeft="22dp",
          paddingRight="22dp",
          w="fill",
          h="fill",
          id="project_rv"
        }

       else

        return {
          RecyclerView,
          paddingLeft="14dp",
          paddingRight="14dp",
          w="fill",
          h="fill",
          id="project_rv"
        }

      end

    end)()
  }
}