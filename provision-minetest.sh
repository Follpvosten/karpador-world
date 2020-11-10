#!/bin/sh

freebsd-update fetch --not-running-from-cron | cat
freebsd-update install --not-running-from-cron || echo "No updates available"

ASSUME_ALWAYS_YES=yes pkg upgrade -y
ASSUME_ALWAYS_YES=yes pkg install -y rsync git-lite minetest minetest_game py37-requests

mkdir -p /var/db/minetest

/usr/local/bin/git clone \
    --recurse-submodules \
    --single-branch \
    https://github.com/Follpvosten/karpador-world.git \
    /var/db/minetest/world

cd /var/db/minetest/world/worldmods/skinsdb/updater
/usr/local/bin/python3 update_skins.py with_preview

chown -R minetest:minetest /var/db/minetest

CONF_PATH=/var/db/minetest/world/minetest.conf
[ -f ${CONF_PATH} ] && cp ${CONF_PATH} /usr/local/etc/minetest.conf

sysrc minetest_enable="YES"
service minetest start

pw usermod root -s /bin/tcsh
