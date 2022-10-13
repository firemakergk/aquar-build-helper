pve下安装施耐德ups配套软件及简单配置 

1.在pve的节点下打开console，安装apcupsd程序

```shell
apt-get install apcupsd
```

2.执行`cp /etc/apcupsd/apcupsd.conf /etc/apcupsd/apcupsd.conf.bak`备份原有的配置文件

3.执行`vi /etc/apcupsd/apcupsd.conf`打开配置文件，修改默认配置文件中的两处配置。

(1).注释掉默认的DEVICE配置，大概在第90行位置，否则会无法连接到ups

![3bef7ed8dd3b8f7f65a9c2e62315b8a7.png](../_resources/a0d646ae41714818bf8785601077d6bc.png)

(2).修改TIMEOUT配置为3，即电池供电3分钟后尝试关机。此处默认为0，意为不根据供电时间触发关机。

![c4769c18649c6f4b024738789d417160.png](../_resources/b5792b45c0eb4f9f9954ce1a9a9e76d8.png)

3.重启apcupsd服务

```shell
systemctl restart apcupsd.service
```

4.执行apcaccess查看状态，若输出与下图类似，有剩余电量信息及输出电压信息等，即表示ups连接正常。

![b1513ca071840f76314d2902a48abee7.png](../_resources/7e91242cec7c481c9d898665ca1b9d12.png)

5.拔掉ups的电源测试系统是否可以被正常关机