#!/bin/bash

# Memperbarui dan menginstal paket dasar yang diperlukan
pkg update -y && pkg upgrade -y
pkg install -y wget curl unzip

#############################
# Instalasi Oh My Posh
#############################

# Menentukan direktori untuk binari oh-my-posh
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Menentukan versi oh-my-posh yang kompatibel dengan Termux dan URL unduhan
OMP_VERSION="v14.10.0"
OMP_BIN="posh-linux-arm64"
OMP_URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/$OMP_VERSION/$OMP_BIN"

# Mengunduh dan memasang binari oh-my-posh
wget "$OMP_URL" -O "$BIN_DIR/oh-my-posh"
chmod +x "$BIN_DIR/oh-my-posh"

# Menambahkan binari oh-my-posh ke PATH jika belum ada
if ! grep -q "$BIN_DIR" <<< "$PATH"; then
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    export PATH=$HOME/.local/bin:$PATH
fi

# Mengunduh tema Craver langsung dari repositori oh-my-posh
THEME_DIR="$HOME/.poshthemes"
mkdir -p "$THEME_DIR"
wget "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" -O "$THEME_DIR/themes.zip"
unzip -o "$THEME_DIR/themes.zip" -d "$THEME_DIR"
rm "$THEME_DIR/themes.zip"

# Mengonfigurasi oh-my-posh untuk menggunakan tema Craver
if ! grep -q "oh-my-posh" ~/.bashrc; then
    echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/craver.omp.json)"' >> ~/.bashrc
fi

#############################
# Instalasi Font Hack Nerd Font
#############################

# Direktori untuk font Termux
FONT_DIR="$HOME/.termux"
mkdir -p "$FONT_DIR"

# Mengunduh dan memasang font Hack Nerd Font
wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip" -O "$FONT_DIR/Hack.zip"
unzip -o "$FONT_DIR/Hack.zip" -d "$FONT_DIR"
rm "$FONT_DIR/Hack.zip"

# Pilih varian font Hack Nerd Font Regular dan hapus font lain untuk menghemat ruang
FONT_FILE=$(ls "$FONT_DIR" | grep 'HackNerdFont-Regular.ttf' | head -n 1)
if [ -n "$FONT_FILE" ]; then
    mv "$FONT_DIR/$FONT_FILE" "$FONT_DIR/font.ttf"
    # Menghapus semua file ttf lainnya di direktori ~/.termux
    find "$FONT_DIR" -type f ! -name 'font.ttf' -delete
else
    echo "Font Hack Nerd Font tidak ditemukan."
fi

#############################
# Konfigurasi Tampilan Kursor Termux
#############################

# File konfigurasi termux.properties
TERMUX_PROPERTIES="$HOME/.termux/termux.properties"
mkdir -p "$(dirname "$TERMUX_PROPERTIES")"
if [ ! -f "$TERMUX_PROPERTIES" ]; then
    echo "terminal-cursor-style=bar" > "$TERMUX_PROPERTIES"
else
    if ! grep -q "^terminal-cursor-style=" "$TERMUX_PROPERTIES"; then
        echo "terminal-cursor-style=bar" >> "$TERMUX_PROPERTIES"
    else
        sed -i 's/^terminal-cursor-style=.*/terminal-cursor-style=bar/' "$TERMUX_PROPERTIES"
    fi
fi

# Memuat ulang pengaturan Termux agar perubahan tampilan kursor dan font diterapkan
termux-reload-settings

echo "Instalasi Oh My Posh dengan tema Craver, font Hack Nerd Font, dan pengaturan kursor selesai. Silakan restart Termux untuk melihat perubahan."