TrueNas配置SMB

1.确认在[用户配置章节](./truenas下配置用户及权限.md)创建的用户aquar勾选了samba Ahthentication选项。

![6e5a6adc7045af3bbd274e231353fa4d.png](../_resources/d3059300019042f08886358e0a52e045.png)

2.在TrueNAS Web页面的Services功能下，把SMB服务打开，点击后面的编辑按钮可以查看具体的配置，我没有做任何修改，截图如下。

![637fb462020e4b38aa396a0d472ccb9b.png](../_resources/637fb462020e4b38aa396a0d472ccb9b.png)

![8b093014573d57d4a6cba249a2814df7.png](../_resources/8b093014573d57d4a6cba249a2814df7.png)

3.然后转到sharing下配置想要共享出去的目录，选择存储池的根目录，配置上同样没有做什么特殊的改动，截图供参考。

![45771324e2a045b3845e45238ae7a9a7.png](../_resources/45771324e2a045b3845e45238ae7a9a7.png)

![23559d3d55244676ae6fdb64dae0c7fc.png](../_resources/23559d3d55244676ae6fdb64dae0c7fc.png)


4.在同一个局域网中，在文件管理器显示各个硬盘页面的空白处右键，选择“添加一个网络位置”。

![7641b8dc7e9f47219edfad997f4e9649.png](../_resources/7641b8dc7e9f47219edfad997f4e9649.png)

![585e52c259e8406e82414fc63f6c2c51.png](../_resources/585e52c259e8406e82414fc63f6c2c51.png)

5.一番下一步后会让你输入地址，填写truenas的服务地址然后又是一番下一步，最后会询问你用户名和密码，这时候就填写你在TrueNas上新创建的用户的名称和密码即可。

![7d6662074d4a73110e9e328733d59905.png](../_resources/fcb260b9749b416cb38e074cad45f8b9.png)

![e6828a4afe6b37f92994f19cf5d8ee85.png](../_resources/b9ad144097f9410bb76de881188ecf1d.png)