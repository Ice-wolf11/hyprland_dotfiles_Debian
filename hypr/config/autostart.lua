-- =========================================================
-- AUTOSTART
-- =========================================================

hl.on("hyprland.start", function()

    -- Hypridle
    hl.exec_cmd("hypridle")

    -- Cliphist: text history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")

    -- Cliphist: image history
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Polkit authentication agent
    hl.exec_cmd("/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1")

    -- Noctalia Shell
    hl.exec_cmd("noctalia --daemon")

end)
