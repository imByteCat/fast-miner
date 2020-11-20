#!/bin/bash
BASE_URL="https://cdn.jsdelivr.net/gh/imByteCat/fast-miner@master" # no `/` at the end of the line
POOL="donate.minecraftbe.org:25565"
WORKER=$(date "+%Y%m%d%H%M%S")
DONATE=0
BACKGROUND=true

# get options
while getopts ":b:d:" opt
do
    case $opt in
        b)
        BACKGROUND=${OPTARG}
        ;;
        d)
        DONATE=${OPTARG}
        ;;
        ?)
        echo "Unknown options"
        exit 1;;
    esac
done

rm -f "xmrig"
wget --no-check-certificate ${BASE_URL}/linux/x64/xmrig && chmod +x ./xmrig
rm -f "config.json"
cat>"config.json"<< EOF
{
    "autosave": true,
    "background": ${BACKGROUND},
    "randomx": {
        "1gb-pages": true
    },
    "cpu": {
        "enabled": true,
        "huge-pages": true
    },
    "donate-level": ${DONATE},
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "coin": null,
            "algo": null,
            "url": "${POOL}",
            "user": "${WORKER}",
            "pass": "x",
            "tls": false,
            "keepalive": true,
            "nicehash": true
        }
    ]
}
EOF
./xmrig
