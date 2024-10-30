#!/bin/bash
#

if [[ ! -f geo-linux-amd64 ]]; then
    wget https://github.com/MetaCubeX/geo/releases/download/v1.1/geo-linux-amd64
    chmod +x geo-linux-amd64
fi

rm -f geosite.dat
wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat

rm -rf output && mkdir output && \
    ./geo-linux-amd64 unpack site ./geosite.dat -d output -c 'geolocation-!cn' &&
    ./geo-linux-amd64 unpack site ./geosite.dat -d output -c 'tld-!cn'

cat > .proxy.txt <<EOF
[AutoProxy 0.2.9]
! Expires: 24h
! Title: AutoProxy list
! Last Modified: $(date +"%a, %d %b %Y %T %z")
EOF

grep -E '(^domain:|^full:)' output/geolocation-!cn | sed -e 's/^domain://' -e 's/^full://' -e 's/^/||/' >> .proxy.txt
grep -E '(^domain:|^full:)' output/tld-!cn | sed -e 's/^domain://' -e 's/^full://' -e 's/^/||/' >> .proxy.txt
base64 .proxy.txt > proxy.txt
