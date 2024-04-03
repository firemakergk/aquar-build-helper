echo '********开始修改pve源为国内源********'
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
mv /etc/apt/sources.list.d/ceph.list /etc/apt/sources.list.d/ceph.list.bak

if ! grep -q '##\[aquar config start\]##' /etc/apt/sources.list;
then
    cp /etc/apt/sources.list /etc/apt/sources.list.bak
    cat > /etc/apt/sources.list <<EOF
##[aquar config start]##
deb https://mirrors.ustc.edu.cn/debian/ bookworm main contrib non-free
deb https://mirrors.ustc.edu.cn/debian/ bookworm-updates main contrib non-free
deb https://mirrors.ustc.edu.cn/debian/ bookworm-backports main contrib non-free
deb https://mirrors.ustc.edu.cn/debian-security bookworm-security main contrib 
deb https://mirrors.ustc.edu.cn/proxmox/debian bookworm pve-no-subscription
##[aquar config end]##
EOF
else
    echo '********探测到已配置成功，跳过/etc/fstab的配置********'
fi
apt update
apt install pve-kernel-6.2
proxmox-boot-tool kernel list
proxmox-boot-tool kernel pin 6.2.11-2-pve
echo '*******配置vmbr1********'

if ! grep -q 'vmbr1' /etc/network/interfaces;
then
    cp /etc/network/interfaces /etc/network/interfaces.bak
    sed -i '/iface vmbr0 inet static/s/static/dhcp/g' /etc/network/interfaces
    sed -i '/address [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/d' /etc/network/interfaces
    sed -i '/gateway [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/d' /etc/network/interfaces
    cat >> /etc/network/interfaces <<EOF

auto vmbr1
iface vmbr1 inet static
        address 192.168.172.1/24
        bridge-ports none
        bridge-stp off
        bridge-fd 0
EOF
else
    echo '********探测到已配置成功，跳过/etc/network/interfaces的配置********'
fi

echo '*******安装ipupdater.py脚本********'
# sed '/(^10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}.+$)|(^172\.1[6-9]\.[0-9]{1,3}\.[0-9]{1,3}.+$)|(^172\.2[0-9]\.[0-9]{1,3}\.[0-9]{1,3}.+$)|(^172\.3[0-1]\.[0-9]{1,3}\.[0-9]{1,3}.+$)|(^192\.168\.[0-9]{1,3}\.[0-9]{1,3}.+$)/s/static/dhcp/g' /etc/hosts
## 扫描hosts中的内容，取出带有私有地址的那一行，找到后面跟的host名称，赋值到变量，然后带入到下面的脚本中
pve_host=$(awk '{print $1}' /etc/hostname)

cat > /root/ipupdater.py <<EOF
#! /usr/bin/env python
# vim: set fenc=utf8 ts=4 sw=4 et :
# -----------/lib/systemd/system/ipupdater.service systemd配置---------------
# [Unit]
# Description=update ip config when system start
# After=network-online.target
# 
# [Service]
# Type=simple
# User=root
# ExecStart=python3 /root/ipupdater.py 
# 
# [Install]
# WantedBy=multi-user.target


import socket
import shutil
import re

NTERFACE_PATH = '/etc/network/interfaces'
HOSTS_PATH = '/etc/hosts'
ISSUE_PATH = '/etc/issue'

def getRealNetInfo():
    # defaultGateWay, defaultInterface = ni.gateways()['default'][ni.AF_INET]
    # addressInfo = ni.ifaddresses(defaultInterface)[ni.AF_INET][0]
    # ip = addressInfo['addr']
    # maskBits = IPv4Network('0.0.0.0/'+addressInfo['netmask']).prefixlen
    # return ip, defaultGateWay, maskBits
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(0)
    try:
        # doesn't even have to be reachable
        s.connect(('10.254.254.254', 1))
        ip = s.getsockname()[0]
    except Exception:
        ip = '127.0.0.1'
    finally:
        s.close()
    return ip 

def checkIfIpChanged(ip, defaultGateWay):
    shutil.copy(INTERFACE_PATH, INTERFACE_PATH + '.bak')
    targetFile = open(INTERFACE_PATH, "r")
    configText = targetFile.read()

    addressMatch = re.search(' {8}address (.+)\n',configText)
    if addressMatch is None or len(addressMatch.groups()) == 0:
        print("pve静态IP配置文件%s中未找到IP地址信息，配置文件内容:%s" % (NTERFACE_PATH, configText) )
        return False
    configIp = addressMatch.groups()[0][:-3]

    gatewayMatch = re.search(' {8}gateway (.+)\n',configText)
    if gatewayMatch is None or len(gatewayMatch.groups()) == 0:
        print("pve静态IP配置文件%s中未找到默认路由信息，配置文件内容:%s" % (NTERFACE_PATH, configText) )
        return False
    configGateway = gatewayMatch.groups()[0]
    if defaultGateWay == configGateway and ip == configIp:
        return False
    else:
        return True

def updateInterfaces(ip, gateway, maskBits):
    shutil.copy(INTERFACE_PATH, INTERFACE_PATH + '.bak')
    targetFile = open(INTERFACE_PATH, "r+")
    configText = targetFile.read()
    splitRes = re.split(" {8}address .+\n {8}gateway .+\n", configText)
    prepart = splitRes[0]
    postpart = splitRes[1]
    updateConfig = "        address %s/%s\n        gateway %s\n" % (ip, maskBits, gateway)
    print("interfaces updateConfig: %s" % updateConfig)
    newConifg = prepart + updateConfig+ postpart
    print("interfaces newConifg:%s" % newConifg)

    targetFile.seek(0)
    targetFile.write(newConifg)
    targetFile.truncate()
    targetFile.close()

def updateHosts(ip):
    shutil.copy(HOSTS_PATH, HOSTS_PATH + '.bak')
    targetFile = open(HOSTS_PATH, "r+")
    configText = targetFile.read()
    splitRes = re.split("\n.+ ${pve_host}\n", configText)
    print(splitRes)
    prepart = splitRes[0]
    postpart = splitRes[1]
    updateConfig = "\n%s ${pve_host}\n" % ip
    print("----host updateConfig----\n %s" % updateConfig)
    newConifg = prepart + updateConfig+ postpart
    print("----host newConifg----\n%s" % newConifg)

    targetFile.seek(0)
    targetFile.write(newConifg)
    targetFile.truncate()
    targetFile.close()

def updateIssue(ip):
    shutil.copy(ISSUE_PATH, ISSUE_PATH + '.bak')
    targetFile = open(ISSUE_PATH, "r+")
    configText = targetFile.read()
    splitRes = re.split("  https://.+:8006/\n", configText)
    prepart = splitRes[0]
    postpart = splitRes[1]
    updateConfig = "  https://%s:8006/\n" % ip
    print("----issue updateConfig----\n%s" % updateConfig)
    newConifg = prepart + updateConfig+ postpart
    print("----issue newConifg----\n%s" % newConifg)

    targetFile.seek(0)
    targetFile.write(newConifg)
    targetFile.truncate()
    targetFile.close()


if __name__ == "__main__":
    print('ipupdater start.')
    ip = getRealNetInfo()
    print("ip:%s" % ip)
    updateHosts(ip)
    updateIssue(ip)
EOF

cat > /lib/systemd/system/ipupdater.service <<EOF
[Unit]
Description=update ip config when system start
After=network-online.target

[Service]
Type=simple
User=root
ExecStart=python3 /root/ipupdater.py 

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ipupdater.service

ls -l /dev/disk/by-id/
# 获取到这个命令的磁盘信息

qm set 101 -sata1 /dev/disk/by-id/ata-ST4000VX015-3CU104_WW618Q3D
qm set 101 -sata2 /dev/disk/by-id/ata-ST4000VX015-3CU104_WW6199F0

# 配置TrueNAS的存储池


cp /etc/default/grub /etc/default/grub.bak
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/s/quiet/quiet quiet intel_iommu=on iommu=pt initcall_blacklist=sysfb_init pcie_acs_override=downstream/g' /etc/default/grub

cat > /etc/modules <<EOF
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
EOF

cat > /etc/modprobe.d/blacklist.conf <<EOF
blacklist snd_hda_intel
blacklist snd_hda_codec_hdmi
blacklist i915
EOF
update-grub
update-initramfs -u -k all
#####重启######
reboot

# 从配置中拿出8086:4680的部分
gpu_info=$(lspci -n -s 00:02 | perl -n -e'/00\:02.+? .+: (.+\:.+) \(rev 06\)/ && print $1')
cat > /etc/modprobe.d/vfio.conf <<EOF
options vfio-pci ids=${gpu_info}
EOF

# 配置TrueNAS的网卡
######################Ubuntu中执行##########################
# 配置Ubuntu的网卡
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak

cat > /etc/netplan/00-installer-config.yaml <<EOF
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: true
    ens19:
      dhcp4: false
      addresses:
        - 192.168.172.3/24
      routes:
         - to: 192.168.172.0/24
           via: 0.0.0.0
           metric: 100
      nameservers:
        addresses: [8.8.8.8,114.114.114.114,192.168.3.1]
EOF

apt install -y intel-gpu-tools
apt install -y libmfx1 libmfx-tools
apt install -y libva-dev libmfx-dev intel-media-va-driver-non-free

cat >> /etc/bash.bashrc <<EOF
export LIBVA_DRIVER_NAME=iHD
EOF

cat > /etc/modprobe.d/i915.conf <<EOF
options i915 enable_guc=2
undate-initramfs -u -k all
EOF