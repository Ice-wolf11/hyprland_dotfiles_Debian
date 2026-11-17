-- General settings

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,

        col = {
            active_border = "rgba(cba6f7ff)",
            inactive_border = "rgba(585b70aa)"
        },

        resize_on_border = false,
        allow_tearing = true,
        layout = "dwindle"
    },

    input = {
        kb_layout = "latam",
        follow_mouse = 1,
        numlock_by_default = true,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false
        }
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.92,

        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            vibrancy = 0.15
        },

        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
            color = "rgba(1a1a1aee)"
        }
    },

    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false
    },

    master = {
        new_status = "master"
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0
    },

    xwayland = {
        force_zero_scaling = true
    },

    cursor = {
        no_hardware_cursors = 0
    },

    render = {
        direct_scanout = 2
    }
})
