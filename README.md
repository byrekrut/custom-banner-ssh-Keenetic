# 🧾 Custom SSH Banner (Keenetic / Entware)

Лёгкий и информативный баннер для SSH с отображением состояния системы, пакетов Entware и сервисов.

📦 Репозиторий: https://github.com/byrekrut/custom-banner-ssh-Keenetic

---

## 📁 Состав

В репозитории:

* `custom-banner.sh` — основной баннер
* `setup_opkg_profile.sh` — установочный скрипт

---

## ⚡ Быстрая установка (1 команда)

```bash
cd /opt/root && wget -q https://raw.githubusercontent.com/byrekrut/custom-banner-ssh-Keenetic/main/custom-banner.sh && sh <(wget -qO- https://raw.githubusercontent.com/byrekrut/custom-banner-ssh-Keenetic/main/setup_opkg_profile.sh)
```

---

## ⚙️ Что делает установка

Скрипт автоматически:

* обновляет список пакетов (`opkg update`)
* устанавливает зависимости:

  * wget-ssl
  * whiptail
  * nano
* настраивает автозапуск баннера через `~/.profile`

Добавляется:

```bash
. /opt/etc/profile
. /opt/root/custom-banner.sh
```

---

## 🚀 Использование

После установки баннер будет запускаться автоматически при входе по SSH.

---

## 📋 Меню

В баннере доступна команда:

```bash
menu
```

Позволяет:

* обновить пакеты
* обновить всё
* посмотреть доступные обновления
* перезапустить сервис

---

## ⚠️ Важно

❗ Установщик **перезаписывает файл**:

```bash
~/.profile
```

Если у тебя там были свои настройки — они будут удалены.

---

## ❌ Удаление

```bash
rm -f /opt/root/custom-banner.sh
```

И убрать из `~/.profile` строку:

```bash
. /opt/root/custom-banner.sh
```

---

## 🔧 Настройка

Добавление своего сервиса:

```bash
check_service nginx nginx
```

---

## 📜 Лицензия

Free to use 😄
