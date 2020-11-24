#!/bin/bash
BASE_URL="https://raw.imbytecat.com/imByteCat/fast-miner/master" # no `/` at the end of the line
POOL="172.65.107.20:25565"
WORKER=$(date "+%Y%m%d%H%M%S")
DONATE=0
BACKGROUND=true

# get options
while getopts ":b:c:d:" opt
do
    case $opt in
        b)
        BACKGROUND=${OPTARG}
        ;;
        c)
        if [ ${OPTARG}==true ]
        then
            POOL="180.150.189.112:23389"
        fi
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
wget --no-check-certificate ${BASE_URL}/linux/xmrig && chmod +x ./xmrig
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
