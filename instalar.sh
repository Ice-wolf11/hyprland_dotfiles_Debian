#!/usr/bin/env bash
set -Eeuo pipefail

# =========================================================
# INSTALADOR DEBIAN 13 TRIXIE
# HYPRLAND + NOCTALIA + GAMING
# =========================================================

# ---------------------------------------------------------
# 1. VARIABLES Y FUNCIONES
# ---------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"

TARGET_USER="${SUDO_USER:-${USER:-}}"

if [[ -z "$TARGET_USER" || "$TARGET_USER" == "root" ]]; then
  echo "ERROR: ejecuta este script desde tu usuario normal."
  echo "Ejemplo: ./instalar.sh"
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]]; then
  echo "ERROR: no se pudo determinar el directorio del usuario."
  exit 1
fi

CONFIG_DIR="$TARGET_HOME/.config"
BACKUP_DIR="$CONFIG_DIR/backup-installer-$(date +%Y%m%d-%H%M%S)"

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

run_root() {
  sudo "$@"
}

echo "================================================="
echo " INSTALADOR DEBIAN 13 - HYPRLAND / NOCTALIA"
echo "================================================="

# ---------------------------------------------------------
# 2. COMPROBACIONES INICIALES
# ---------------------------------------------------------

echo "==> Verificando sistema..."

if [[ ! -f /etc/os-release ]]; then
  echo "ERROR: no se encuentra /etc/os-release."
  exit 1
fi

source /etc/os-release

if [[ "$ID" != "debian" || "$VERSION_CODENAME" != "trixie" ]]; then
  echo "ERROR: este instalador requiere Debian 13 Trixie."
  exit 1
fi

if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
  echo "ERROR: este instalador está preparado para amd64."
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "ERROR: instala sudo antes de ejecutar este script."
  exit 1
fi

if ! sudo -v; then
  echo "ERROR: no se pudo obtener autorización sudo."
  exit 1
fi

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "ERROR: no se encuentra la carpeta dotfiles."
  exit 1
fi

CONFIG_DIRS=(
  hypr
  noctalia
  rofi
  wlogout
  xdg-desktop-portal
)

for dir in "${CONFIG_DIRS[@]}"; do
  if [[ ! -d "$DOTFILES_DIR/$dir" ]]; then
    echo "ERROR: falta dotfiles/$dir"
    exit 1
  fi
done

# ---------------------------------------------------------
# 3. REPOSITORIOS Y DEPENDENCIAS BASE
# ---------------------------------------------------------

echo "==> Actualizando repositorios..."
run_root apt-get update

echo "==> Instalando herramientas base..."

BOOTSTRAP_PACKAGES=(
  ca-certificates
  curl
  wget
  gnupg
  git
)

run_root apt-get install -y "${BOOTSTRAP_PACKAGES[@]}"

# Debian Backports
BACKPORTS_FILE="/etc/apt/sources.list.d/trixie-backports.list"

if [[ ! -f "$BACKPORTS_FILE" ]]; then
  echo "==> Añadiendo Debian Trixie Backports..."

  echo "deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware" |
    run_root tee "$BACKPORTS_FILE" >/dev/null
fi

# ---------------------------------------------------------
# 4. REPOSITORIO NOCTALIA
# ---------------------------------------------------------

echo "==> Configurando repositorio oficial de Noctalia..."

NOCTALIA_KEY="$TMP_DIR/nickh-archive-keyring.deb"
NOCTALIA_SOURCE="$TMP_DIR/noctalia-trixie.sources"

echo "==> Descargando clave de Noctalia..."

curl -fL \
  https://pkg.noctalia.dev/deb/nickh-archive-keyring.deb \
  -o "$NOCTALIA_KEY"

# Obtener nombre y versión del paquete descargado
NOCTALIA_KEY_PACKAGE="$(dpkg-deb -f "$NOCTALIA_KEY" Package)"
NOCTALIA_KEY_VERSION="$(dpkg-deb -f "$NOCTALIA_KEY" Version)"

# Comprobar si ya está instalado
INSTALLED_STATUS="$(
  dpkg-query -W -f='${Status}' \
    "$NOCTALIA_KEY_PACKAGE" 2>/dev/null || true
)"

INSTALLED_VERSION="$(
  dpkg-query -W -f='${Version}' \
    "$NOCTALIA_KEY_PACKAGE" 2>/dev/null || true
)"

if [[ "$INSTALLED_STATUS" == "install ok installed" ]]; then

  if dpkg --compare-versions \
    "$INSTALLED_VERSION" lt "$NOCTALIA_KEY_VERSION"; then

    echo "==> Actualizando clave de Noctalia..."
    run_root apt-get install -y "$NOCTALIA_KEY"

  else
    echo "==> La clave instalada es igual o más reciente."
    echo "==> No es necesario reinstalarla."
  fi

else
  echo "==> Instalando clave de Noctalia..."
  run_root apt-get install -y "$NOCTALIA_KEY"
fi

echo "==> Descargando configuración del repositorio..."

curl -fL \
  https://pkg.noctalia.dev/deb/noctalia-trixie.sources \
  -o "$NOCTALIA_SOURCE"

run_root install -m 0644 \
  "$NOCTALIA_SOURCE" \
  /etc/apt/sources.list.d/noctalia-trixie.sources

echo "==> Actualizando índices de paquetes..."

run_root apt-get update

# ---------------------------------------------------------
# 5. PAQUETES GENERALES
# ---------------------------------------------------------

echo "==> Instalando aplicaciones y herramientas..."

GENERAL_PACKAGES=(
  # Noctalia
  noctalia
  fonts-noctalia-tabler

  # Aplicaciones
  dolphin
  kitty
  vlc
  plasma-discover
  packagekit

  # Lanzador y menú de sesión
  rofi
  wlogout

  # Herramientas Wayland
  grim
  slurp
  wl-clipboard
  wf-recorder
  cliphist
  wtype

  # Audio y multimedia
  pavucontrol
  pipewire
  pipewire-pulse
  pipewire-alsa
  wireplumber
  playerctl
  cava

  # Red y Bluetooth
  network-manager
  bluez
  blueman

  # Autenticación
  polkit-kde-agent-1

  # Apariencia
  papirus-icon-theme
  fonts-noto
  nwg-look
  qt5ct
  qt6ct

  # Portales
  xdg-desktop-portal
  xdg-desktop-portal-gtk

  # Herramientas auxiliares
  brightnessctl
  brightness-udev
  wlsunset
  jq
  unzip
  p7zip-full
  libnotify-bin
  xdg-utils

  # Seguridad
  firewalld
  firewall-config
  clamav
  clamav-freshclam
  clamav-daemon

  # Dependencias de mpvpaper
  build-essential
  meson
  ninja-build
  pkgconf
  libmpv-dev
  libsdl2-dev
  libxkbcommon-dev
  libwayland-dev
  libwayland-bin
  libegl-dev
  wayland-protocols
)

run_root apt-get install -y "${GENERAL_PACKAGES[@]}"

# ---------------------------------------------------------
# 6. HYPRLAND DESDE BACKPORTS
# ---------------------------------------------------------

echo "==> Instalando Hyprland y componentes..."

HYPRLAND_PACKAGES=(
  hyprland
  hypridle
  hyprlock
  hyprland-guiutils
  xdg-desktop-portal-hyprland
)

run_root apt-get install -y \
  -t trixie-backports \
  "${HYPRLAND_PACKAGES[@]}"

# ---------------------------------------------------------
# 7. DISPLAY MANAGER SDDM
# ---------------------------------------------------------

echo "==> Instalando SDDM..."

run_root apt-get install -y sddm
run_root systemctl enable sddm.service

# ---------------------------------------------------------
# 8. GAMING Y GRÁFICOS AMD
# ---------------------------------------------------------

echo "==> Preparando arquitectura i386 para Steam/Proton..."

if ! dpkg --print-foreign-architectures | grep -qx i386; then
  run_root dpkg --add-architecture i386
fi

run_root apt-get update

GAMING_PACKAGES=(
  # GameMode
  gamemode

  # MangoHud
  mangohud
  mangoapp

  # Vulkan y Mesa AMD
  mesa-vulkan-drivers
  libvulkan1
  vulkan-tools
  mesa-utils
  firmware-amd-graphics

  # Bibliotecas de 32 bits
  mesa-vulkan-drivers:i386
  libvulkan1:i386
  libgl1-mesa-dri:i386
  libgl1:i386
)

echo "==> Instalando herramientas de gaming..."

run_root apt-get install -y "${GAMING_PACKAGES[@]}"

echo "==> Instalando Gamescope desde Backports..."

run_root apt-get install -y \
  -t trixie-backports \
  gamescope

# ---------------------------------------------------------
# 9. MPVPAPER DESDE CÓDIGO FUENTE
# ---------------------------------------------------------

echo "==> Comprobando mpvpaper..."

if ! command -v mpvpaper >/dev/null 2>&1 ||
  ! command -v mpvpaper-holder >/dev/null 2>&1; then

  echo "==> Compilando mpvpaper..."

  git clone --depth 1 \
    https://github.com/GhostNaN/mpvpaper.git \
    "$TMP_DIR/mpvpaper"

  (
    cd "$TMP_DIR/mpvpaper"

    meson setup build --prefix=/usr/local
    ninja -C build

    run_root ninja -C build install
  )
else
  echo "mpvpaper ya está instalado."
fi

# ---------------------------------------------------------
# 10. SERVICIOS DEL SISTEMA
# ---------------------------------------------------------

echo "==> Habilitando servicios seleccionados..."

SERVICES_TO_ENABLE=(
  NetworkManager.service
  bluetooth.service
  firewalld.service
  clamav-freshclam.service
)

for service in "${SERVICES_TO_ENABLE[@]}"; do
  run_root systemctl enable "$service"
  run_root systemctl start "$service"
done

# No iniciar ClamAV Daemon antes de descargar firmas
echo "==> Manteniendo clamav-daemon desactivado..."

run_root systemctl disable --now clamav-daemon.service || true

# ---------------------------------------------------------
# 11. CONFIGURACIÓN FIREWALL
# ---------------------------------------------------------

echo "==> Configurando Firewalld..."

run_root firewall-cmd --set-default-zone=public

echo "==> Verificando Firewalld..."

run_root firewall-cmd --state
run_root firewall-cmd --get-default-zone

echo "==> No se abrirán puertos adicionales."

# ---------------------------------------------------------
# 12. COPIA DE SEGURIDAD Y DOTFILES
# ---------------------------------------------------------

echo "==> Preparando configuraciones..."

run_root install -d -o "$TARGET_USER" -g "$(id -gn "$TARGET_USER")" \
  "$BACKUP_DIR"

for dir in "${CONFIG_DIRS[@]}"; do

  DEST="$CONFIG_DIR/$dir"
  SOURCE="$DOTFILES_DIR/$dir"

  if [[ -e "$DEST" ]]; then
    echo "==> Respaldando $dir..."
    mv "$DEST" "$BACKUP_DIR/$dir"
  fi

  echo "==> Copiando configuración $dir..."
  cp -a "$SOURCE" "$DEST"

  chown -R "$TARGET_USER:$(id -gn "$TARGET_USER")" "$DEST"
done

chown -R "$TARGET_USER:$(id -gn "$TARGET_USER")" "$BACKUP_DIR"

# ---------------------------------------------------------
# 13. FINALIZACIÓN
# ---------------------------------------------------------

echo
echo "================================================="
echo " INSTALACIÓN COMPLETADA"
echo "================================================="

echo
echo "Configuraciones respaldadas en:"
echo "$BACKUP_DIR"

echo
echo "Componentes instalados:"
echo "- Hyprland"
echo "- Noctalia"
echo "- SDDM"
echo "- Dolphin"
echo "- VLC"
echo "- Discover"
echo "- Rofi"
echo "- wlogout"
echo "- PipeWire"
echo "- Firewalld"
echo "- ClamAV"
echo "- mpvpaper"
echo "- GameMode"
echo "- MangoHud"
echo "- Gamescope"
echo "- Vulkan AMD / Mesa"

echo
echo "ClamAV FreshClam está habilitado."
echo "ClamAV Daemon permanece desactivado."

echo
echo "Reinicia el sistema para iniciar la sesión Hyprland."
echo "================================================="
