#!/bin/bash

# 1. 修改默认 IP 为 192.168.10.1
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 2. 修改默认主机名为 RAX3000M
sed -i 's/ImmortalWrt/RAX3000M/g' package/base-files/files/bin/config_generate
