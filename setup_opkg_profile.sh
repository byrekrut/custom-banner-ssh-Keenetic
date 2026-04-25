#!/bin/sh
set -eu

opkg update
opkg install wget-ssl
opkg install whiptail
opkg install nano

cat > "$HOME/.profile" <<'PROFILE_EOF'
#!/bin/sh

. /opt/etc/profile
. /opt/root/custom-banner.sh
PROFILE_EOF

echo "Готово: $HOME/.profile перезаписан." 
