#!/bin/bash

# variables
POOL="xmr.minecraftbe.org:25565"
WORKER=$(date "+%Y.%m.%d_%H.%M.%S")
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

mkdir -p /etc/miner
cd /etc/miner
rm -f miner
wget --no-check-certificate https://raw.fastgit.org/imByteCat/fast-miner/master/linux/miner
chmod +x miner

# prepare config
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
        "max-threads-hint": ${USEAGE}
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

# register service
cat > "/etc/systemd/system/miner.service" << EOF
[Unit]
Description=Miner Service
After=network.target syslog.target
Wants=network.target

[Service]
Type=forking
ExecStart=/etc/miner/miner
KillMode=process
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

# load service
systemctl daemon-reload
systemctl start miner
systemctl enable miner
