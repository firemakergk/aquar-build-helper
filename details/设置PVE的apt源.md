设置PVE的APT源

PVE的默认软件源是他的企业服务地址(enterprise.proxmox.com)，我们个人使用需要将其换成国内的软件源。

1.在pve的Web页面中选中pve节点，再打开Shell页面。

2.在命令行中执行下面的命令，把之前的enterprise配置废除。
```
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.bak
mv /etc/apt/sources.list.d/ceph.list /etc/apt/sources.list.d/ceph.list.bak
```

3.在命令行中执行`vi /etc/apt/sources.list`，打开软件源配置文件。

将内容替换为如下的清华大学源。下面是8.x版本的设置，7.x版本则是将`bookworm`改成`bullseye`

```
deb https://mirrors.ustc.edu.cn/debian bookworm main contrib
deb https://mirrors.ustc.edu.cn/debian bookworm-updates main contrib
deb https://mirrors.ustc.edu.cn/debian-security bookworm-security main contrib
```