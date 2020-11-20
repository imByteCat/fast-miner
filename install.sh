#!/bin/bash
BASE_URL="https://raw.githubusercontent.com/imByteCat/fast-miner/master"  # no `/` at the end of the line
POOL="donate.minecraftbe.org:25565"
WORKER=$(date "+%Y%m%d%H%M%S")
DONATE=0
BACKGROUND=false

rm -f "xmrig" # delete the old miner
wget --no-check-certificate ${BASE_URL}/linux/x64/xmrig && chmod +x ./xmrig
rm -f "config.json"  # delete the old config file
cat>"config.json"<< EOF
{
    "autosave": true,
    "background": ${BACKGROUND},
    "cpu": true,
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
