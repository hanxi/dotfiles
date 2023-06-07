local wezterm = require "wezterm"

local launch_menu = {}

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

local default_prog = {"powershell.exe", "ssh", "vm"}

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

local mux = wezterm.mux
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

local tab_bar_style = {
    window_hide = " - ",
    window_maximize = " + ",
    window_close = " X ",

    window_hide_hover = " - ",
    window_maximize_hover = " + ",
    window_close_hover = " X ",
}

local cappuccin = require("lua/catppuccin").select("frappe")
return {
    use_fancy_tab_bar = false,
    window_decorations="INTEGRATED_BUTTONS|RESIZE",
    colors = cappuccin,
    launch_menu = launch_menu,
    mouse_bindings = mouse_bindings,
    default_prog = default_prog,
    harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
    tab_bar_style = tab_bar_style,
}
