local wezterm = require "wezterm"

local config = {}

local launch_menu = {}
config.launch_menu = launch_menu

local ssh_cmd = {"ssh"}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    ssh_cmd = {"powershell.exe", "ssh"}

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
            local args = {}
            for i,v in pairs(ssh_cmd) do
                args[i] = v
            end
            args[#args+1] = host
            table.insert(
                launch_menu,
                {
                    label = "SSH " .. host,
                    args = args,
                }
            )
            -- default open vm
            if host == "vm" then
                config.default_prog = {"powershell.exe", "ssh", "vm"}
            end
        end
        line = f:read("*l")
    end
    f:close()
end

config.mouse_bindings = {
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



wezterm.on( "update-right-status", function(window)
    local date = wezterm.strftime("%Y-%m-%d %H:%M:%S   ")
    window:set_right_status(
        wezterm.format(
            {
                {Text = date}
            }
        )
    )
end)

wezterm.on('format-tab-title', function (tab, _, _, _, _)
    return {
        { Text = ' ' .. tab.tab_index + 1 .. ' ' },
    }
end)

wezterm.on("gui-startup", function()
  local tab, pane, window = wezterm.mux.spawn_window{}
  window:gui_window():maximize()
end)

local window_min = ' 󰖰 '
local window_max = ' 󰖯 '
local window_close = ' 󰅖 '
config.tab_bar_style = {
    window_hide = window_min,
    window_hide_hover = window_min,
    window_maximize = window_max,
    window_maximize_hover = window_max,
    window_close = window_close,
    window_close_hover = window_close,
}

config.use_fancy_tab_bar = false
config.window_decorations="INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }
config.color_scheme = 'Catppuccin Frappe'
config.harfbuzz_features = {"calt=0", "clig=0", "liga=0"}
config.check_for_updates = false

return config
