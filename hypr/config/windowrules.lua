-- =========================================================
-- WINDOW RULES
-- =========================================================

-- CORE FIXES

hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- DIALOGS

hl.window_rule({
	name = "dialogs-float",
	match = {
		title = "^(Open|Save|Confirm|Choose|File Operation Progress).*",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "modal-dialogs",
	match = {
		modal = true,
	},
	float = true,
	center = true,
})

-- FLOATING UTILITIES

hl.window_rule({
	name = "float-pavucontrol",
	match = {
		class = "^(pavucontrol)$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "float-networkmanager",
	match = {
		class = "^(nm-connection-editor)$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "float-blueman",
	match = {
		class = "^(blueman-manager)$",
	},
	float = true,
	center = true,
})

-- MULTIMEDIA

hl.window_rule({
	name = "idle-inhibit-media",
	match = {
		class = "^(mpv|vlc|celluloid)$",
	},
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	name = "idle-inhibit-browser",
	match = {
		class = "^(firefox|LibreWolf|brave-browser|chromium)$",
	},
	idle_inhibit = "fullscreen",
})

-- PICTURE IN PICTURE

hl.window_rule({
	name = "picture-in-picture",
	match = {
		title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture).*",
	},
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	size = { 500, 300 },
})

-- JETBRAINS

hl.window_rule({
	name = "jetbrains-fix",
	match = {
		class = "^(.jetbrains.)$",
		title = "^(win[0-9]+)$",
	},
	no_initial_focus = true,
})

-- STEAM

hl.window_rule({
	name = "steam-friends",
	match = {
		title = "^(Friends List)$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "steam-settings",
	match = {
		title = "^(Steam Settings)$",
	},
	float = true,
	center = true,
})

-- RPCS3

hl.window_rule({
	name = "rpcs3-game-window",
	match = {
		class = "^(rpcs3)$",
		title = "^FPS:.*",
	},
	float = true,
	center = true,
	size = {
		"monitor_w*0.67",
		"monitor_h*0.67",
	},
})

-- CHEATSHEET

hl.window_rule({
	name = "cheatsheet",
	match = {
		title = "^(Hyprland Cheat Sheet)$",
	},
	float = true,
	center = true,
	size = { 1400, 850 },
})

-- POKEFINDER

hl.window_rule({
	name = "PokeFinder",
	match = {
		class = "^(PokeFinder)",
	},
	float = true,
	center = true,
})

-- =========================================================
-- LAYER RULES
-- =========================================================

hl.layer_rule({
	name = "blur-rofi",
	match = {
		namespace = "rofi",
	},
	blur = true,
})

hl.layer_rule({
	name = "ignore-alpha-rofi",
	match = {
		namespace = "rofi",
	},
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "blur-notifications",
	match = {
		namespace = "notifications",
	},
	blur = true,
})

hl.layer_rule({
	name = "ignore-alpha-notifications",
	match = {
		namespace = "notifications",
	},
	ignore_alpha = 0,
})

-- WLOGOUT: CYBERPUNK BLUR
-- WLOGOUT: FROSTED GLASS
hl.layer_rule({
	name = "wlogout-frosted-glass",
	match = {
		namespace = "^logout_dialog$",
	},
	blur = false,
	ignore_alpha = 0.05,
})



-- =========================================================
-- AUTO FLOAT: HEREDAR ESTADO DEL ESCRITORIO
-- =========================================================

hl.on("window.open", function(w)
    if not w or not w.workspace then
        return
    end

    -- Las ventanas que ya son flotantes conservan
    -- sus reglas especiales (PIP, RPCS3, diálogos, etc.).
    if w.floating then
        return
    end

    -- Consultar las ventanas del mismo escritorio.
    local siblings = hl.get_workspace_windows(w.workspace)

    for _, other in ipairs(siblings) do
        if other.address ~= w.address and other.floating then
            local monitor = w.monitor or hl.get_active_monitor()

            if not monitor then
                return
            end

            local width = math.floor((monitor.width / monitor.scale) * 0.93)
            local height = math.floor((monitor.height / monitor.scale) * 0.93)

            -- Convertir la nueva ventana en flotante.
            hl.dispatch(hl.dsp.window.float({
                action = "set",
                window = w
            }))

            -- Aplicar tamaño y centrar.
            hl.dispatch(hl.dsp.window.resize({
                x = width,
                y = height,
                relative = false,
                window = w
            }))

            hl.dispatch(hl.dsp.window.center({
                window = w
            }))

            return
        end
    end
end)
