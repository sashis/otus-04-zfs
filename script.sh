#!/bin/bash


zpool create storage mirror /dev/sd{b,c,d,e}

# Issue 1. Find out the best compression algorithm
for algo in {gzip,gzip-9,zle,lzjb,lz4}; do zfs create storage/$algo -o compression=$algo ; cp -rf /etc /storage/$algo/ ; done
zfs get compressratio

# Issue 2. List imported pool settings
curl -L -o zfs_task1.tar.gz https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download
tar xzf zfs_task1.tar.gz
zpool import -d ./zpoolexport/filea -d ./zpoolexport/fileb -D -f
zfs get available,type,recordsize,compression,checksum otus

# Issue 3. Find the secret message
curl -L -o otus_task2.file https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download
zfs receive otus/storage < otus_task2.file
find /otus/storage/ -type f -name "secret_message" -exec cat {} \;

