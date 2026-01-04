local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.leader = { key = "b", mods = "CTRL" }

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Nerd Font Symbols",
	"Noto Color Emoji",
})

config.font_size = 13.0
config.color_scheme = "Gruvbox dark, hard (base16)"
config.enable_tab_bar = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true
config.scrollback_lines = 20000

config.ssh_domains = {
	{
		name = "ubuntu",
		remote_address = "192.168.253.130",
		username = "chivo",
		assume_shell = "Posix",
		multiplexing = "None", -- important: no remote wezterm needed
	},
	{
		name = "fedora",
		remote_address = "192.168.253.129",
		username = "chivo",
		assume_shell = "Posix",
		multiplexing = "None", -- important: no remote wezterm needed
	},
}

config.wsl_domains = {
	{
		name = "WSL:Ubuntu-22.04",
		distribution = "Ubuntu-22.04",
		username = "chivo",
		default_cwd = "/home/chivo",
	},
	{
		name = "WSL:ArchLinux",
		distribution = "archlinux",
		username = "chivo",
		default_cwd = "/home/chivo",
	},
}

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
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	-- { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	-- { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	-- { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	-- { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
	-- { key = "LeftArrow",  mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
	-- { key = "RightArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
	-- { key = "UpArrow",    mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
	-- { key = "DownArrow",  mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "0", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
	{ key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
	{ key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
	{ key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
	{ key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
	{ key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
	{ key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
	{ key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
	{ key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(8) },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "r", mods = "LEADER", action = wezterm.action.ReloadConfiguration },
	{ key = "m", mods = "LEADER", action = wezterm.action.ShowLauncher },
	{ key = "q", mods = "LEADER", action = wezterm.action.QuitApplication },
}

return config

