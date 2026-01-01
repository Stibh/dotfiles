local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "memory_update" for
-- the memory load data, which is fired every 2.0 seconds.
sbar.exec("killall memory_load >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/memory_load/bin/memory_load memory_update 2.0")

local memory = sbar.add("graph", "widgets.memory", 42, {
    position = "right",
    graph = {
        color = colors.blue
    },
    background = {
        height = 22,
        color = {
            alpha = 0
        },
        border_color = {
            alpha = 0
        },
        drawing = true
    },
    icon = {
        string = icons.memory
    },
    label = {
        string = "mem ??%",
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 9.0
        },
        align = "right",
        padding_right = 0,
        width = 0,
        y_offset = 4
    },
    padding_right = settings.paddings + 6
})

memory:subscribe("memory_update", function(env)
    local used_percentage = tonumber(env.used_percentage)
    memory:push({used_percentage / 100.})

    local color = colors.blue
    if used_percentage > 30 then
        if used_percentage < 60 then
            color = colors.yellow
        elseif used_percentage < 80 then
            color = colors.orange
        else
            color = colors.red
        end
    end

    memory:set({
        graph = {
            color = color
        },
        label = "mem " .. env.used_percentage .. "%"
    })
end)

memory:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the memory item
sbar.add("bracket", "widgets.memory.bracket", {memory.name}, {
    background = {
        color = colors.bg1,
        border_color = colors.rainbow[#colors.rainbow - 6],
        border_width = 1
    }
})

-- Padding
sbar.add("item", "widgets.memory.padding", {
    position = "right",
    width = settings.group_paddings
})
