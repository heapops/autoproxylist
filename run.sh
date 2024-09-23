#!/bin/bash
#

wget https://github.com/MetaCubeX/geo/releases/download/v1.1/geo-linux-amd64
wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat
chmod +x geo-linux-amd64

mkdir output && ./geo-linux-amd64 unpack site ./geosite.dat -d output -c 'geolocation-!cn'

cat > .proxy.txt <<EOF
[AutoProxy 0.2.9]
! Expires: 24h
! Title: AutoProxy list
! Last Modified: $(date +"%a, %d %b %Y %T %z")
EOF

grep -E '(^domain:|^full:)' output/geolocation-!cn | sed -e 's/^domain://' -e 's/^full://' >> .proxy.txt
base64 .proxy.txt > proxy.txt
