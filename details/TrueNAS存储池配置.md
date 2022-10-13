TrueNAS存储池配置

1.登录TrueNAS的Web页面，进入Storage -> Pools 页面，点击ADD按钮

![68a34a6c651b79d866d93092ed8673db.png](../_resources/c6a9e159c329488eaa6c87507d446462.png)

2.选择create new pool。

![5df08c8c83e2666606fc56715d69af83.png](../_resources/fe658411719849b3afc74f21a2098ba3.png)

3.在创建存储池页面上填写存储池名称，选择想要纳入的磁盘，然后点击右箭头。

![2f6eb7e3eee152bfdae9c76c74c381ff.png](../_resources/2f6eb7e3eee152bfdae9c76c74c381ff.png)

4.在右侧下方选择适合自己的RAID类型，图中Mirror等价于RAID1。

![f3f8997d8c3b6bec8597bee2a3beb217.png](../_resources/cb4ec60883ef4e3ca6c7aacd4725e1c3.png)

5.点击左下角的CREATE按钮，即可创建出名为aquar_pool的存储池