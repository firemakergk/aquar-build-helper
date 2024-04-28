# 开机IP自检及更新脚本
1.打开PVE的shell界面。

2.将[ipupdater.py](../files/ipupdater.py)拷贝至`/root/`目录下
在/root目录下使用rz工具或者使用vi/vim创建文件并复制脚本文本。

3.使用`awk '{print $1}' /etc/hostname`命令查看你的pve使用的hostname。然后用这个名称替换掉脚本的第85行以及第89行的“pve”字样。
``` python
def updateHosts(ip):
    shutil.copy(HOSTS_PATH, HOSTS_PATH + '.bak')
    targetFile = open(HOSTS_PATH, "r+")
    configText = targetFile.read()
    splitRes = re.split("\n.+ pve\n", configText) # 这一行的“pve”换成你自己查到的hoatname
    print(splitRes)
    prepart = splitRes[0]
    postpart = splitRes[1]
    updateConfig = "\n%s pve\n" % ip # 这一行的“pve”换成你自己查到的hoatname
    print("----host updateConfig----\n %s" % updateConfig)
    newConifg = prepart + updateConfig+ postpart
    print("----host newConifg----\n%s" % newConifg)

    targetFile.seek(0)
    targetFile.write(newConifg)
    targetFile.truncate()
    targetFile.close()
```

3.将[ipupdater.service](../files/ipupdater.service)拷贝至`/lib/systemd/system/`目录下

4.执行`systemctl daemon-reload`重载系统服务。

5.执行`systemctl enable ipupdater.service`将脚本设置为开机启动