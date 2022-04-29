local colors = require("lua/rose-pine").colors()
local window_frame = require("lua/rose-pine").window_frame()

local wezterm = require "wezterm"

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    table.insert(
        launch_menu,
        {
            label = "Bash",
            args = {"C:/Program Files/Git/bin/bash.exe", "-li"}
        }
    )

    table.insert(
        launch_menu,
        {
            label = "CMD",
            args = {"cmd.exe"}
        }
    )

    table.insert(
        launch_menu,
        {
            label = "PowerShell",
            args = {"powershell.exe", "-NoLogo"}
        }
    )

end

local ssh_config_file = wezterm.home_dir .. "/.ssh/config"
local f = io.open(ssh_config_file)
if f then
    local line = f:read("*l")
    while line do
        if line:find("Host ") == 1 then
            local host = line:gsub("Host ", "")
            table.insert(
                launch_menu,
                {
                    label = "SSH " .. host,
                    args = {"powershell.exe", "ssh", host}
                }
            )
        end
        line = f:read("*l")
    end
    f:close()
end

local mouse_bindings = {
    -- 右键粘贴
    {
        event = {Down = {streak = 1, button = "Right"}},
        mods = "NONE",
        action = wezterm.action {PasteFrom = "Clipboard"}
    },
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
        event = {Up = {streak = 1, button = "Left"}},
        mods = "NONE",
        action = wezterm.action {CompleteSelection = "PrimarySelection"}
    },
    -- and make CTRL-Click open hyperlinks
    {
        event = {Up = {streak = 1, button = "Left"}},
        mods = "CTRL",
        action = "OpenLinkAtMouseCursor"
    }
}

local default_prog = {"powershell.exe", "ssh", "home"}

wezterm.on(
    "update-right-status",
    function(window)
        local date = wezterm.strftime("%Y-%m-%d %H:%M:%S ")
        window:set_right_status(
            wezterm.format(
                {
                    {Text = date}
                }
            )
        )
    end
)

return {
    color_scheme = "rose-pine",
    colors = colors,
    window_frame = window_frame, -- needed only if using fancy tab
    launch_menu = launch_menu,
    mouse_bindings = mouse_bindings,
    default_prog = default_prog
}
