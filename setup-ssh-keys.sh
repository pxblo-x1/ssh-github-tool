#!/bin/bash
# setup-pi.sh - Initial setup script for Raspberry Pi 5
#
# Copyright (c) Pablo Pin - devidence.dev
# Licensed for personal and educational use only. See README for details.
# This script is provided "as-is" without any warranty.
# You are free to modify and distribute this script for personal use.
#
# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Título con color y emoji
echo -e "${CYAN}🚀 === GitHub SSH Key Setup Script === 🚀${NC}"

# 1. Pedir correo y validar formato
while true; do
    read -p "📧 Ingresa tu correo de GitHub: " GITHUB_EMAIL
    if [[ "$GITHUB_EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        break
    else
        echo -e "${RED}❌ Correo inválido. Intenta de nuevo.${NC}"
    fi
done

# 2. Elegir tipo de llave
echo -e "${YELLOW}🔑 Elige el tipo de llave SSH:${NC}"
select keytype in "ed25519 (recomendado)" "rsa (legacy)"; do
    case $keytype in
        "ed25519 (recomendado)")
            ALGO="ed25519"
            break
            ;;
        "rsa (legacy)")
            ALGO="rsa"
            break
            ;;
    esac
done

# 3. Ruta del archivo
KEY_PATH="$HOME/.ssh/id_${ALGO}_github"
read -p "📝 Nombre para tu archivo de llave SSH (default: $KEY_PATH): " CUSTOM_PATH
if [ ! -z "$CUSTOM_PATH" ]; then
    KEY_PATH="$CUSTOM_PATH"
fi

# 4. Generar la llave
echo -e "${CYAN}🔨 Generando llave SSH...${NC}"
if [ "$ALGO" = "ed25519" ]; then
    ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH"
else
    ssh-keygen -t rsa -b 4096 -C "$GITHUB_EMAIL" -f "$KEY_PATH"
fi

# 5. Iniciar ssh-agent y agregar llave
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

# 6. Mostrar llave pública e instrucciones
echo -e "${GREEN}✅ Tu nueva llave pública SSH:${NC}"
echo "--------------------------------------"
cat "${KEY_PATH}.pub"
echo "--------------------------------------"
echo
echo -e "${YELLOW}📋 Copia la llave anterior y agrégala a tu cuenta de GitHub:${NC}"
echo "  1. Ve a GitHub > Settings > SSH and GPG keys"
echo "  2. Haz clic en 'New SSH key', pega la llave y guarda."
echo

# 7. Subida automática opcional
read -p "🤖 ¿Quieres subir la llave automáticamente a GitHub? (y/n): " UPLOAD
if [[ "$UPLOAD" =~ ^[Yy]$ ]]; then
    read -p "👤 Usuario de GitHub: " GHUSER
    read -s -p "🔑 Token personal de GitHub (con admin:public_key): " GHTOKEN
    echo

    PUBKEY=$(cat "${KEY_PATH}.pub")
    TITLE=$(hostname)
    RESPONSE=$(curl -s -H "Authorization: token ${GHTOKEN}" \
        -X POST --data-binary "{\"title\":\"${TITLE}\",\"key\":\"${PUBKEY}\"}" \
        https://api.github.com/user/keys)

    if echo "$RESPONSE" | grep -q '"key":'; then
        echo -e "${GREEN}🎉 Llave subida exitosamente a GitHub.${NC}"
    else
        echo -e "${RED}❌ Falló la subida. Verifica tu token e intenta de nuevo.${NC}"
    fi
fi

# 8. Configurar archivo SSH config
CONFIG_ENTRY="Host github.com\n    HostName github.com\n    User git\n    IdentityFile $KEY_PATH\n"
echo -e "${CYAN}🛠️ Actualizando ~/.ssh/config...${NC}"
echo "$CONFIG_ENTRY" >> ~/.ssh/config
chmod 600 ~/.ssh/config

# 9. Probar conexión
echo -e "${YELLOW}🔗 Probando conexión SSH con GitHub...${NC}"
ssh -T git@github.com

echo -e "${GREEN}🎊 ¡Configuración completa! Ya puedes usar SSH con GitHub.${NC}"