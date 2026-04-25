#!/bin/sh

. /opt/etc/profile

# ===== Цвета =====

purple="\033[38;5;141m"
pink="\033[38;5;212m"
green="\033[38;5;78m"
blue="\033[38;5;117m"
orange="\033[38;5;214m"
line="\033[38;5;250m"
text="\033[38;5;252m"
yellow="\033[38;5;220m"
red="\033[38;5;196m"
reset="\033[0m"

clear

# ===== Баннер =====

printf "${blue}"
cat << 'EOF'
            _______   _________       _____    ____  ______
           / ____/ | / /_  __/ |     / /   |  / __ \/ ____/
          / __/ /  |/ / / /  | | /| / / /| | / /_/ / __/
         / /___/ /|  / / /   | |/ |/ / ___ |/ _, _/ /___
        /_____/_/ |_/ /_/    |__/|__/_/  |_/_/ |_/_____/
EOF
printf "${reset}\n"

# ===== Температура =====

if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
TEMP_VAL=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
TEMP="${TEMP_VAL}°C"
else
TEMP_VAL=0
TEMP="N/A"
fi

if [ "$TEMP_VAL" -lt 55 ]; then
TEMP_COLOR="$green"
elif [ "$TEMP_VAL" -lt 70 ]; then
TEMP_COLOR="$yellow"
else
TEMP_COLOR="$red"
fi

# ===== Процессы =====

PROCS="$(ls /proc | grep -E '^[0-9]+$' | wc -l)"

# ===== Entware (БЕЗ update) =====

INSTALLED="$(opkg list-installed 2>/dev/null | wc -l)"
UPGRADABLE="$(opkg list-upgradable 2>/dev/null | grep -c .)"

# ===== Получение версии =====

get_version() {

PKG="$1"

case "$PKG" in
  nfqws2) PKG="nfqws2-keenetic" ;;
  adguard) PKG="adguardhome-go" ;;
  sing-box) PKG="sing-box-naive" ;;
esac

opkg list-installed 2>/dev/null | awk -v name="$PKG" '$1==name {print $3}'
}

# ===== Чередование цветов =====

ROW=0
next_color() {
if [ $((ROW % 2)) -eq 0 ]; then
ROW_COLOR="$purple"
else
ROW_COLOR="$pink"
fi
ROW=$((ROW+1))
}

# ===== Верхний блок =====

next_color
printf "%b %-12s%b ${text}%s${reset}\n" "$ROW_COLOR" "Date:" "$reset" "$(date)"

UPTIME="$(cat /proc/uptime | awk '{print int($1/86400)"d "int(($1%86400)/3600)"h "int(($1%3600)/60)"m"}')"
next_color
printf "%b %-12s%b ${text}%s${reset}\n" "$ROW_COLOR" "Uptime:" "$reset" "$UPTIME"

next_color
printf "%b %-12s%b %b%s%b\n" "$ROW_COLOR" "CPU Temp:" "$reset" "$TEMP_COLOR" "$TEMP" "$reset"

next_color
printf "%b %-12s%b ${text}%s${reset}\n" "$ROW_COLOR" "Processes:" "$reset" "$PROCS"

next_color
printf "%b %-12s%b ${text}%s${reset}\n" "$ROW_COLOR" "Installed:" "$reset" "$INSTALLED"

next_color
printf "%b %-12s%b ${text}%s${reset}\n" "$ROW_COLOR" "Upgradable:" "$reset" "$UPGRADABLE"

echo

# ===== Разделитель =====

WIDTH=60
TITLE="Running services"

LEN=${#TITLE}
SIDE=$(( (WIDTH - LEN - 2) / 2 ))

LEFT=$(printf "%${SIDE}s" "" | tr " " "─")
RIGHT=$(printf "%$((WIDTH - LEN - SIDE - 2))s" "" | tr " " "─")

printf "${line}%s %s %s${reset}\n\n" "$LEFT" "$TITLE" "$RIGHT"

# ===== Заголовок =====

printf "  ${orange}%-22s %-10s %s${reset}\n" "SERVICE" "STATUS" "VERSION"

# ===== Проверка сервиса =====

check_service() {

NAME="$1"
PROC="$2"

VER="$(get_version "$NAME")"
[ -z "$VER" ] && return

if pidof "$PROC" >/dev/null 2>&1; then
STATUS="running"
ICON="${green}●${reset}"
else
STATUS="stopped"
ICON="${red}●${reset}"
fi

next_color

printf "%b%b %b%-22s%b ${green}%-10s${reset} ${blue}%s${reset}\n" \
"$ROW_COLOR" "$ICON" "$ROW_COLOR" "$NAME" "$reset" "$STATUS" "$VER"
}

# ===== Сервисы =====

check_service sing-box sing-box
check_service xray xray
check_service lighttpd lighttpd
check_service hrweb hrweb
check_service hrneo hrneo
check_service nfqws2 nfqws2
check_service nfqws-keenetic-web lighttpd
check_service adguard AdGuardHome
check_service awg-manager awg-manager

echo

printf "${line}%${WIDTH}s${reset}\n" "" | tr " " "─"

# ===== Подсказка =====

echo
printf "${yellow}Type 'menu' to open Entware menu${reset}\n"

# ===== МЕНЮ =====

menu() {

while true; do

CHOICE=$(whiptail --title "Entware Menu" --menu "Выбери действие" 15 50 6 \
"1" "Update packages" \
"2" "Upgrade all" \
"3" "List upgradable" \
"4" "Restart service" \
"0" "Exit" 3>&1 1>&2 2>&3)

[ $? -ne 0 ] && break

case "$CHOICE" in
  1) opkg update ;;
  2) opkg upgrade ;;
  3) opkg list-upgradable | less ;;
  4)
    svc=$(whiptail --inputbox "Service name:" 8 40 3>&1 1>&2 2>&3)
    [ $? -ne 0 ] && continue
    killall "$svc" 2>/dev/null
    "$svc" &
    ;;
  0) break ;;
esac

done
}
