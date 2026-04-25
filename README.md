# 🧾 Custom SSH Banner (Keenetic / Entware)

Простой и удобный баннер для SSH с информацией о системе, пакетах Entware и сервисах.

📦 Репозиторий: https://github.com/byrekrut/custom-banner-ssh-Keenetic

---

## 📁 Состав

В репозитории есть 2 файла:

* `custom-banner.sh` — сам баннер
* `setup_opkg_profile.sh` — скрипт установки

---

## ⚙️ Что делает установщик

Скрипт `setup_opkg_profile.sh`:

* обновляет пакеты:

  ```bash
  opkg update
  ```

* устанавливает зависимости:

  * wget-ssl
  * whiptail
  * nano

* полностью перезаписывает:

  ```bash
  ~/.profile
  ```

* добавляет автозапуск:

  ```bash
  . /opt/etc/profile
  . /opt/root/custom-banner.sh
  ```

---

## 📥 Установка

### 1. Скачать файлы

```bash
cd /opt/root
wget https://raw.githubusercontent.com/byrekrut/custom-banner-ssh-Keenetic/main/custom-banner.sh
wget https://raw.githubusercontent.com/byrekrut/custom-banner-ssh-Keenetic/main/setup_opkg_profile.sh
```

---

### 2. Выдать права

```bash
chmod +x custom-banner.sh
chmod +x setup_opkg_profile.sh
```

---

### 3. Запустить установку

```bash
sh setup_opkg_profile.sh
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
* посмотреть обновления
* перезапустить сервис

---

## ⚠️ Важно

❗ Скрипт перезаписывает файл:

```bash
~/.profile
```

Если у тебя там были свои настройки — они будут удалены.

---

## ❌ Удаление

1. Удалить баннер:

```bash
rm -f /opt/root/custom-banner.sh
```

2. Очистить автозапуск:

```bash
nano ~/.profile
```

Удалить строку:

```bash
. /opt/root/custom-banner.sh
```

---

## 🔧 Настройка

Добавление сервиса:

```sh
Можно добавлять свои сервисы или полностью изменить по желанию самим.
```

---

## 📜 Лицензия

Free to use 😄
