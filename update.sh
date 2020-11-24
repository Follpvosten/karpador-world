#!/bin/sh
git pull
git submodule update --init --recursive
cp minetest.conf /usr/local/etc/minetest.conf
