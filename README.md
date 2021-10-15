# ZFS

Домашнее задания разработано для курса **[Administrator Linux. Professional](https://otus.ru/lessons/linux-professional/?int_source=courses_catalog&int_term=operations?utm_source=github&utm_medium=free&utm_campaign=otus)**

## 1. Определить алгоритм с наилучшим сжатием.

Из имеющихся дисков создадим пул
```
zpool create storage mirror /dev/sd{b,c,d,e}
```
Создадим файловые системы с разными алгоритмами сжатия и произведем в них запись
```
for algo in {gzip,gzip-9,zle,lzjb,lz4}; do 
    zfs create storage/$algo -o compression=$algo
    cp -rf /etc /storage/$algo/
done
```
Наилучшим оказался алгоритм - `gzip-9`
```
[root@server vagrant]# zfs get compressratio
 NAME            PROPERTY       VALUE  SOURCE
 storage         compressratio  2.34x  -
 storage/gzip    compressratio  4.03x  -
 storage/gzip-9  compressratio  4.11x  -
 storage/lz4     compressratio  2.49x  -
 storage/lzjb    compressratio  2.18x  -
 storage/zle     compressratio  1.28x  -
 ```

 ## 2. Определить настройки pool'а.
 
 Загружаем и распаковываем архив с пулом ZFS
 ```
 curl -L -o zfs_task1.tar.gz https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download
 tar xzf zfs_task1.tar.gz
 ```
 Собираем пул из имеющихся файлов
 ```
 zpool import -d ./zpoolexport/filea -d ./zpoolexport/fileb -a
 ```
 Определяем требуемые настройки
 ```
 [root@server vagrant]# zfs get available,type,recordsize,compression,checksum otus
 NAME  PROPERTY     VALUE       SOURCE
 otus  available    350M        -
 otus  type         filesystem  -
 otus  recordsize   128K        local
 otus  compression  zle         local
 otus  checksum     sha256      local
 ```

 ## 3. Найти сообщение от преподавателей.

 Скачиваем снэпшот
 ```
 curl -L -o otus_task2.file https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download
 ```
 Восстанавливаем его
 ```
 zfs receive otus/storage < otus_task2.file
 ```
 Находим сообщение
 ```
 [root@server vagrant]# find /otus/storage/ -type f -name "secret_message" -exec cat {} \;
 https://github.com/sindresorhus/awesome
 ```