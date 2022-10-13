把pve配置成DHCP

1.在pve的Web页面中选中pve节点，再打开Shell页面。

2.在命令行中执行`cp /etc/network/interfaces /etc/network/interfaces.bak`，备份当前的网络配置文件。

3.在命令行中执行`vi /etc/network/interfaces`，打开网络配置文件。

默认情况下pve的配置类似下面这样：

```
auto lo
iface lo inet loopback

iface enp0s31f6 inet manual

auto vmbr0
iface vmbr0 inet static
        address 192.168.0.99/24
        gateway 192.168.0.1
        bridge-ports enp0s31f6
        bridge-stp off
        bridge-fd 0

iface enp3s0 inet manual
```

4.将vmbr0原本的静态IP配置修改成dhcp，配置完成后类似如下形式。

```
auto lo
iface lo inet loopback

iface enp0s31f6 inet manual

auto vmbr0
iface vmbr0 inet dhcp

iface enp3s0 inet manual
```