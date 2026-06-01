#!/bin/bash

set -e

echo "==> Verificando sistema..."

if ! grep -q "VERSION_CODENAME=trixie" /etc/os-release; then
    echo "ERROR: Este instalador está pensado para Debian 13 (Trixie)."
    exit 1
fi

echo "==> Configurando repositorios..."

# --------------------------------------------------
# Debian 13 Backports
# --------------------------------------------------

if [ ! -f /etc/apt/sources.list.d/trixie-backports.list ]; then
    echo "Agregando repositorio Backports..."

    echo "deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware" \
        | sudo tee /etc/apt/sources.list.d/trixie-backports.list >/dev/null
fi

# --------------------------------------------------
# Repositorio Noctalia
# --------------------------------------------------

sudo mkdir -p /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/noctalia.gpg ]; then
    echo "Agregando clave GPG de Noctalia..."

    curl -fsSL https://pkg.noctalia.dev/gpg.key \
        | sudo gpg --dearmor \
        -o /etc/apt/keyrings/noctalia.gpg
fi

if [ ! -f /etc/apt/sources.list.d/noctalia.list ]; then
    echo "Agregando repositorio Noctalia..."

    echo "deb [signed-by=/etc/apt/keyrings/noctalia.gpg] https://pkg.noctalia.dev/apt trixie main" \
        | sudo tee /etc/apt/sources.list.d/noctalia.list >/dev/null
fi

# --------------------------------------------------
# Actualizar repositorios
# --------------------------------------------------

echo "==> Actualizando repositorios..."
sudo apt update

# --------------------------------------------------
# Instalar paquetes generales
# --------------------------------------------------

echo "==> Instalando paquetes generales..."

sudo apt install -y \
    noctalia-shell \
    grim \
    slurp \
    wl-clipboard \
    wf-recorder \
    cliphist \
    rofi \
    pavucontrol \
    network-manager \
    blueman \
    papirus-icon-theme \
    fonts-noto \
    nwg-look \
    qt5ct \
    qt6ct \
    git \
    curl \
    wget

# --------------------------------------------------
# Instalar stack Hyprland desde Backports
# --------------------------------------------------

echo "==> Instalando stack Hyprland desde Backports..."

sudo apt install -y -t trixie-backports \
    hyprland \
    hypridle \
    hyprlock \
    xdg-desktop-portal-hyprland

# --------------------------------------------------
# Copiar dotfiles
# --------------------------------------------------

echo "==> Instalando dotfiles..."

mkdir -p "$HOME/.config"

for dir in hypr noctalia rofi xdg-desktop-portal; do
    if [ -d "$dir" ]; then
        echo "Copiando $dir..."
        rm -rf "$HOME/.config/$dir"
        cp -r "$dir" "$HOME/.config/"
    else
        echo "Advertencia: no se encontró la carpeta '$dir'"
    fi
done

# --------------------------------------------------
# Finalización
# --------------------------------------------------

echo ""
echo "========================================"
echo " Instalación completada correctamente "
echo "========================================"
echo ""
echo "Se instalaron:"
echo "  • Noctalia Shell"
echo "  • Hyprland (Backports)"
echo "  • Hypridle (Backports)"
echo "  • Hyprlock (Backports)"
echo "  • XDG Desktop Portal Hyprland (Backports)"
echo "  • Rofi"
echo "  • Cliphist"
echo "  • Herramientas multimedia"
echo ""
echo "Se copiaron los dotfiles a ~/.config."
echo ""
echo "Próximos pasos:"
echo "  1. Reiniciar el sistema (recomendado)"
echo "  2. Seleccionar Hyprland en el gestor de inicio de sesión"
echo "  3. Iniciar sesión"
echo ""
