TrueNAS下的NFS服务配置

1.在TrueNAS的Web页面上进入Services页面，将NFS服务开关打开。

![87892a6868557ca0344b48b8dda97b72.png](../_resources/85e089975854448cb637d6e99384f375.png)

2.点击后面的编辑按钮，设置Number of servers为cpu核数，这里我给虚拟机的核数是2，所以填2。

![d3c8e0fe2a910c79c383bc6de3bc7874.png](../_resources/7e6a82c0bee34c5ead12305e92ed034b.png)

3.进入Sharing->Unix Shares(NFS)页面，点击右上角的ADD按钮，新建一个共享目录

![edf7d381b24a8e59c819547224bd862d.png](../_resources/b4dbb09c0b5a42ea836526364ef4d709.png)

4.在表单中选择/mnt/目录下自己存储池同名的文件夹

![76f74ba7d7254ffd9caa591ab3d99a4f.png](../_resources/76f74ba7d7254ffd9caa591ab3d99a4f.png)

5.点击ADVANCED OPTIONS，高级选项。设置NFS的描述信息，勾选Enabled启用NFS共享，然后在高级选项中设置为将所有用户的操作都映射为aquar用户。（aquar用户创建步骤及原因解释请参考用户配置章节）

![85795e1dd83644b69ed566e054e88a61.png](../_resources/5577632edc96492c8e5500cffa25d2e0.png)

![5a3753260e58342e3e00cc3a75fabada.png](../_resources/d5d867d248f041e4932a5a7f6716b01a.png)

6.配置完成后点击SAVE保存NFS配置。