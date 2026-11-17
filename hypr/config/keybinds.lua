-- =========================================================
-- KEYBINDS
-- =========================================================

local mainMod = "SUPER"

-- =========================================================
-- APPLICATIONS
-- =========================================================

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave-browser"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun -theme ~/.config/rofi/themes/noctalia.rasi"))

-- =========================================================
-- WINDOW MANAGEMENT
-- =========================================================

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

--hl.bind(mainMod .. " + CTRL + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + CTRL + V", function()
    local window = hl.get_active_window()
    local monitor = hl.get_active_monitor()

    if window == nil or monitor == nil then
        return
    end

    if window.floating then
        -- Volver a mosaico
        hl.dispatch(hl.dsp.window.float({ action = "unset" }))
    else
        -- Convertir a flotante
        local w = math.floor((monitor.width / monitor.scale) * 0.93)
        local h = math.floor((monitor.height / monitor.scale) * 0.93)

        hl.dispatch(hl.dsp.window.float({ action = "set" }))
        hl.dispatch(hl.dsp.window.resize({
            x = w,
            y = h,
            relative = false
        }))
        hl.dispatch(hl.dsp.window.center())
    end
end)


hl.bind(mainMod .. " + CTRL + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.alter_zorder({ mode = "top" }))

hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.alter_zorder({ mode = "bottom" }))

-- =========================================================
-- FOCUS
-- =========================================================

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- =========================================================
-- RESIZE WINDOWS
-- =========================================================

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })

hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })

hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- =========================================================
-- WORKSPACES 1-8
-- =========================================================

for i = 1, 8 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))

	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Relative workspace navigation

hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))

hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "r-1" }))

-- Relative window movement

hl.bind(mainMod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }))

hl.bind(mainMod .. " + CTRL + ALT + left", hl.dsp.window.move({ workspace = "r-1" }))

-- =========================================================
-- SCRATCHPAD
-- =========================================================

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- =========================================================
-- MOUSE MOVE / RESIZE
-- =========================================================

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- =========================================================
-- ALT + TAB
-- =========================================================

--local ipc = "noctalia msg"
--hl.bind("ALT + Tab", hl.dsp.exec_cmd("~/.config/hypr/scripts/window-switcher.sh"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("noctalia msg window-switcher hold"))

-- =========================================================
-- LOCK SCREEN
-- =========================================================

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- =========================================================
-- AUDIO
-- =========================================================

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)

hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

-- =========================================================
-- SCREENSHOTS
-- =========================================================

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))

hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("grim - | wl-copy"))

hl.bind("Print", hl.dsp.exec_cmd([[grim ~/Imágenes/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png]]))

hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" ~/Imágenes/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png]]))

-- =========================================================
-- CLIPBOARD HISTORY
-- =========================================================

hl.bind(
	mainMod .. " + V",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy")
)

-- =========================================================
-- SCREEN RECORDING
-- =========================================================

hl.bind(
	mainMod .. " + CTRL + R",
	hl.dsp.exec_cmd([[wf-recorder -g "$(slurp)" -f ~/Vídeos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4]])
)

hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.exec_cmd("pkill wf-recorder"))

-- =========================================================
-- SHOW KEYBINDS
-- =========================================================

hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("~/.config/hypr/scripts/show-keybinds.sh"))

-- =========================================================
-- SESSION MENU (WLOGOUT)
-- =========================================================

hl.bind(
	mainMod .. " + Escape",
	hl.dsp.exec_cmd("wlogout --layout ~/.config/wlogout/layout --css ~/.config/wlogout/style.css")
)
