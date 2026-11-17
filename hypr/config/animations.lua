-- Animation configuration

hl.config({
    animations = {
        enabled = true
    }
})

-- Bezier curves
hl.curve("easeOutQuint", {
    type = "bezier",
    points = {
        {0.23, 1},
        {0.32, 1}
    }
})

hl.curve("easeInOutCubic", {
    type = "bezier",
    points = {
        {0.65, 0.05},
        {0.36, 1}
    }
})

hl.curve("linear", {
    type = "bezier",
    points = {
        {0, 0},
        {1, 1}
    }
})

hl.curve("almostLinear", {
    type = "bezier",
    points = {
        {0.5, 0.5},
        {0.75, 1}
    }
})

hl.curve("quick", {
    type = "bezier",
    points = {
        {0.15, 0},
        {0.1, 1}
    }
})

-- Global
hl.animation({
    leaf = "global",
    enabled = true,
    speed = 7,
    bezier = "easeOutQuint"
})

-- Windows
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint"
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "popin 85%"
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "quick",
    style = "popin 85%"
})

-- Borders and fade
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5,
    bezier = "quick"
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3,
    bezier = "quick"
})

-- Layers
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint"
})

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade"
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 3,
    bezier = "quick",
    style = "fade"
})

-- Workspaces
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint"
})

-- Zoom
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 5,
    bezier = "quick"
})
