local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()
local DEFAULT_WORKSPACE = 'main'

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or { workspace = DEFAULT_WORKSPACE })
  window:gui_window():maximize()
end)

wezterm.on('format-tab-title', function(tab)
  local title = tab.tab_title
  if title and #title > 0 then
    return title
  end
  return tab.active_pane.title
end)

config.font = wezterm.font('MonoLisa')
config.freetype_load_flags = 'NO_HINTING'
config.font_size = 12
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.window_background_opacity = 1.0

config.keys = {
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'H', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
  { key = 'n', mods = 'LEADER', action = act.SpawnWindow },
  { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = '0', mods = 'LEADER', action = act.ActivateTab(9) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },
  { key = 'r', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },
  { key = 'v', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'y', mods = 'LEADER', action = act.CopyTo 'Clipboard' },
  { key = 'p', mods = 'LEADER', action = act.PasteFrom 'Clipboard' },
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Rename tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line and #line > 0 then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = '<',
    mods = 'LEADER|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      window:active_tab():set_title('')
    end),
  },
  { key = 'A', mods = 'LEADER|SHIFT', action = act.SwitchToWorkspace { name = DEFAULT_WORKSPACE } },
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  {
    key = 's',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Switch/Create workspace',
      action = wezterm.action_callback(function(window, pane, line)
        if line and #line > 0 then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },
  { key = 'S', mods = 'LEADER|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = 'T', mods = 'LEADER|SHIFT', action = act.ShowTabNavigator },
  { key = ' ', mods = 'LEADER', action = act.ShowLauncher },
}

config.mouse_bindings = {
  { event = { Up = { streak = 1, button = 'Left' } }, mods = 'NONE', action = act.CompleteSelection 'ClipboardAndPrimarySelection' },
}

return config
