TrueNAS下的WebDAV服务配置

1.在TrueNAS的Web界面中进入Services页面，将WebDAV服务的开关打开

![06f2764266e0c221ea570285f4d77572.png](../_resources/ce486e0366f741cb8b61aa802d952ddc.png)

2.点击后面的编辑按钮，选择鉴权方式选择Basic Authentication，设置自己的webDAV服务密码。

![ee40c1c2b2639a60c183c0f3af3ce4a9.png](../_resources/76de1056ba184222936721441b00fa43.png)

3.进入Sharing-> WebDAV Shares页面，点击ADD按钮，创建新的WebDAV共享目录。

![365b629e6d66c32c2dd8623ae66ce984.png](../_resources/067093e3af4548daa056cf986b1054c9.png)

4.选择自己想要使用WebDAV服务共享的目录，这里我只需要使用WebDAV同步joplin笔记数据，所以仅选择了存放joplin数据的目录。另外需勾选Change User & Group Ownership选项，在TrueNAS下，WebDAV服务的用户名必须是"webdav"，我尝试赋权给其他用户但没有成功。

![d879f753b18a4ca299d421bf69b0a370.png](d879f753b18a4ca299d421bf69b0a370.png)

5.验证服务

打开浏览器，输入`http:[TrueNAS内网地址]:8080[/WebDAV服务的名称]`（例如http://192.168.0.104:8080/webdav）如果页面弹出登录提示说明服务已经启动。

![dd641520f2e1759f293fb39275d2e71f.png](../_resources/8d607b024a8942bf8f95e774b353942a.png)

用户名填写webdav，密码填写在Services页面设置的密码，即可在网页中看到共享目录中的内容。

![40f08230c3924e93918c84621d990f3e.png](../_resources/40f08230c3924e93918c84621d990f3e.png)