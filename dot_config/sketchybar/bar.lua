local settings = require("settings")

-- Equivalent to the --bar domain
sbar.bar({
    topmost = "window",
    height = settings.bar.height,
    color = settings.bar.background,
    padding_right = settings.bar.padding.x,
    padding_left = settings.bar.padding.x,
    y_offset = 20,
    sticky = true,
    position = "top",
    shadow = false
})
