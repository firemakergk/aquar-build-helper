# 开机IP自检及更新脚本
1.打开PVE的
1.安装netifaces软件包
```
apt-get install python3-netifaces
```

2.将[ipupdater.py](../files/ipupdater.py)拷贝至`/root/`目录下
在/root目录下使用rz工具或者使用vi/vim创建文件并复制脚本文本。

3.将[ipupdater.service](../files/ipupdater.service)拷贝至`/lib/systemd/system/`目录下
