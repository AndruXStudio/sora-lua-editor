local LinearLayoutCompat = bindClass "androidx.appcompat.widget.LinearLayoutCompat"
local CircularProgressIndicator = bindClass "com.google.android.material.progressindicator.CircularProgressIndicator"

return {
  LinearLayoutCompat,
  w="fill",
  h="fill",
  {
    LinearLayoutCompat,
    gravity="center",
    orientation="vertical",
    w="fill",
    h="150dp",
    {
      CircularProgressIndicator,
      indeterminate=true,
      indicatorSize="55dp",
      trackCornerRadius="5dp",
      trackThickness="5dp"
    },
  }
}