Установка!

1) На Carbon Reductor
```yum -y install git m4```

!!!ВНИМАНИЕ, если Вы уже использете хук для load_ip.sh, то содержимое файла load_ip.sh следует перенести вручную
Копируем содержимое директории hooks на сервер Carbon Reductor в /usr/local/Reductor/userinfo/hooks

2) На серверe c BIND9
Директорию named_client, копируем на сервер с BIND9, пути в скрипте адаптированы под FreeBSD, можете изменить на свои.
Пример добавления запуска client.sh из crontab, описано в файле fakezone.crontab
ВНИМАНИЕ!!! На клиенте необходимо организовать доступ к редуктору по ssh без пароля.

3) На клиенте добавляем использование сгенерированных зон.
В конфиг named сервера (/usr/local/etc/namedb/named.conf) добавляем:
```include "/usr/local/etc/namedb/reductor.conf";```
