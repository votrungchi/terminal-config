local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 800}

config.font = wezterm.font_with_fallback({
	"JetBrainsMonoNL Nerd Font",
})

config.font_size = 13.0
config.color_scheme = "Gruvbox dark, hard (base16)"
config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true
config.scrollback_lines = 20000

config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-l" }

wezterm.on("update-right-status", function(window, pane)
	-- "Wed Mar 3 08:14"
	local date = wezterm.strftime("%a %b %-d %H:%M ")

	local bat = " "
	local battery_info = wezterm.battery_info()

	if #battery_info > 0 then
		for _, b in ipairs(battery_info) do
			bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100)
		end
	else
		bat = "⚡"
	end

	window:set_right_status(wezterm.format({
		{ Text = bat .. "   " .. date },
	}))
end)

wezterm.on("update-status", function(window, _)
	local leader = ""
	if window:leader_is_active() then
		leader = "🪄"
	end
	window:set_left_status(leader)
end)

-- Right-click behavior: copy selection or paste
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				-- Copy selection and clear it
				window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(wezterm.action.ClearSelection, pane)
			else
				-- Paste from clipboard if nothing selected
				window:perform_action(wezterm.action.PasteFrom("Clipboard"), pane)
			end
		end),
	},
}

config.keys = {
	{ key = 'b', mods = 'LEADER|CTRL', action = wezterm.action.SendKey({ key = 'b', mods = 'CTRL' }) },
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = 's', mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "m", mods = "LEADER", action = wezterm.action.ShowLauncher },
	{ key = "q", mods = "LEADER", action = wezterm.action.QuitApplication },
}

for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wezterm.action.ActivateTab(i)
  })
end

return config

