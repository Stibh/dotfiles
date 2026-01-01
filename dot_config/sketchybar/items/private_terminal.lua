local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local terminal = sbar.add("item", {
    icon = {
        font = settings.icons,
        string = ":terminal:",
        padding_right = 8,
        padding_left = 8,
        color = colors.white
    },
    label = {
        drawing = false
    },
    background = {
        color = settings.items.colors.background,
        border_color = colors.blue,
        border_width = 1
    },
    padding_left = 1,
    padding_right = 1,
    click_script = "osascript -e 'tell application \"Terminal\" to do script \"\"'"
})

-- Padding to the right of the terminal button
sbar.add("item", {
    width = 7
})
