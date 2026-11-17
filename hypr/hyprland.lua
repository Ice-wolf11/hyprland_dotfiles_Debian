-- =========================================================
-- HYPRLAND LUA CONFIGURATION
-- Hyprland 0.55.2
-- =========================================================

local config_dir = os.getenv("HOME") .. "/.config/hypr/config/"

-- Module search path
package.path = config_dir .. "?.lua;" .. package.path

-- Environment
require("env")

-- Monitors
require("monitors")

-- General settings
require("settings")

-- Animations
require("animations")

-- Window and layer rules
require("windowrules")

-- Keybindings
require("keybinds")

-- Gestures
require("gestures")

-- Autostart
require("autostart")
