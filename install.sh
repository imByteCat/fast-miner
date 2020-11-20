#!/bin/bash
BASE_URL="https://raw.githubusercontent.com/imByteCat/fast-miner/master"  # no `/` at the end of the line
POOL="donate.minecraftbe.org:25565"
WORKER=$(date "+%Y%m%d%H%M%S")

rm -f "xmrig" # delete the old miner
wget --no-check-certificate ${BASE_URL}/linux/x64/xmrig && chmod +x ./xmrig
rm -f "config.json"  # delete the old config file
cat>"config.json"<< EOF
{
    "autosave": true,
    "cpu": true,
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
