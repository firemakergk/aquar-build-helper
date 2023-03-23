如果你遇到了搬家或者更换路由器的情况，你网络中所有的设备都会失去原有的IP地址，这会导致Aquar中各个子系统间原本建立起来的关联会全部失效。

truenasseeker.py脚本就是用来解决这个问题的。它在每次开机时会检查系统是否有效地挂载了`/opt/aquar/storages/aquarpool`目录，如果这个目录没有正常挂载，则会载局域网中扫描truenas主机，并修改ubuntu的nfs配置为最最新地址，然后重新挂载这个这个地址。

如果你已经部署了truenasseeker.py但在网络变动后发现docker应用中的存储池数据仍然不见了，你可以在ubuntu控制台上以超级用户执行一次`aqserv restart`命令,或者干脆重启一次机器，再看存储池内容是否恢复了。

1.`sudo -i`切换超级用户。

2.安装依赖的软件包。

```shell
apt install -y nmap
pip install scapy python-nmap pyfunctional
```

3.将[truenasseeker.py](../files/truenasseeker.py)脚本拷贝至`/opt/aquar/src`路径下。

你可以尝试执行`python3 /opt/aquar/src/truenasseeker.py`命令运行一次看是否会出错，正常情况下它会输出"truenas seeker is no need to do anything."

4.创建`/usr/lib/systemd/system/truenas-scan.service`配置文件,配置内容如下：

```
[Unit]
Description=scan local network for truenas
After=docker.service opt-aquar-storages-aquarpool.mount

[Service]
Type=simple
User=root
ExecStart=python3 /opt/aquar/src/truenasseeker.py

[Install]
WantedBy=multi-user.target
```

5.执行`systemctl daemon-reload`重载系统服务。

6.执行`systemctl enable truenas-scan.service`将脚本设置为开机启动。

7.执行`systemctl status truenas-scan.service`查看服务在loaded那一行是否为enabled。如果是，则代表脚本正常部署了。