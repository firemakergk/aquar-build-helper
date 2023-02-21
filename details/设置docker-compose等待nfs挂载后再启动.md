设置docker-compose等待nfs挂载后再启动

默认情况下docker-compose中的服务和nfs挂载动作的执行是不区分先后顺序的，这会导致开机以后docker服务已经启动但nfs挂载点未就绪，于是在docker应用中就无法正常的看到存储池中的文件了。所以这一步是必不可少的。

1.执行`sudo -i`进入管理员角色

2.执行`systemctl list-units | grep mount`寻找与fstab中配置对应的信息

```
# systemctl list-units | grep mount
  proc-sys-fs-binfmt_misc.automount                                                                                     loaded active waiting   Arbitrary Executable File Formats File System Automount Point                                   
  -.mount                                                                                                               loaded active mounted   Root Mount                                                                                      
  boot.mount                                                                                                            loaded active mounted   /boot                                                                                           
  dev-hugepages.mount                                                                                                   loaded active mounted   Huge Pages File System                                                                          
  dev-mqueue.mount                                                                                                      loaded active mounted   POSIX Message Queue File System                                                                 
  opt-aquar-storages-aquarpool.mount                                                                                    loaded active mounted   /opt/aquar/storages/aquarpool                                                                   
  run-docker-netns-2b854d157421.mount                                                                                   loaded active mounted   /run/docker/netns/2b854d157421                                                                  
  run-docker-netns-3485b90319b6.mount                                                                                   loaded active mounted   /run/docker/netns/3485b90319b6                                                                  
  run-docker-netns-3502525b2e5c.mount                                                                                   loaded active mounted   /run/docker/netns/3502525b2e5c                                                                  
  run-docker-netns-64d92d4b4f3a.mount                                                                                   loaded active mounted   /run/docker/netns/64d92d4b4f3a                                                                  
  run-docker-netns-70efe6d06b39.mount                                                                                   loaded active mounted   /run/docker/netns/70efe6d06b39                                                                  
  run-docker-netns-7af927c29aa1.mount                                                                                   loaded active mounted   /run/docker/netns/7af927c29aa1                                                                  
  run-docker-netns-90d4316ec7d5.mount                                                                                   loaded active mounted   /run/docker/netns/90d4316ec7d5                                                                  
  run-docker-netns-a400eb46fb12.mount                                                                                   loaded active mounted   /run/docker/netns/a400eb46fb12                                                                  
  run-docker-netns-a9464875f88b.mount                                                                                   loaded active mounted   /run/docker/netns/a9464875f88b                                                                  
  run-docker-netns-ba42ec9fab09.mount                                                                                   loaded active mounted   /run/docker/netns/ba42ec9fab09                                                                  
  run-docker-netns-ffb36b3ff871.mount                                                                                   loaded active mounted   /run/docker/netns/ffb36b3ff871                                                                  
  run-rpc_pipefs.mount                                                                                                  loaded active mounted   RPC Pipe File System                                                                            
  run-snapd-ns-lxd.mnt.mount                                                                                            loaded active mounted   /run/snapd/ns/lxd.mnt                                                                           
  run-snapd-ns.mount                                                                                                    loaded active mounted   /run/snapd/ns                                                                                   
  run-user-1000.mount                                                                                                   loaded active mounted   /run/user/1000                                                                                  
  snap-core18-1944.mount                                                                                                loaded active mounted   Mount unit for core18, revision 1944                                                            
  snap-core18-2344.mount                                                                                                loaded active mounted   Mount unit for core18, revision 2344                                                            
  snap-core20-1405.mount                                                                                                loaded active mounted   Mount unit for core20, revision 1405                                                            
  snap-core20-1434.mount                                                                                                loaded active mounted   Mount unit for core20, revision 1434                                                            
  snap-lxd-19188.mount                                                                                                  loaded active mounted   Mount unit for lxd, revision 19188                                                              
  snap-lxd-22753.mount                                                                                                  loaded active mounted   Mount unit for lxd, revision 22753                                                              
  snap-snapd-15177.mount                                                                                                loaded active mounted   Mount unit for snapd, revision 15177                                                            
  snap-snapd-15534.mount                                                                                                loaded active mounted   Mount unit for snapd, revision 15534                                                            
  sys-fs-fuse-connections.mount                                                                                         loaded active mounted   FUSE Control File System                                                                        
  sys-kernel-config.mount                                                                                               loaded active mounted   Kernel Configuration File System                                                                
  sys-kernel-debug.mount                                                                                                loaded active mounted   Kernel Debug File System                                                                        
  sys-kernel-tracing.mount                                                                                              loaded active mounted   Kernel Trace File System                                                                        
  var-lib-docker-overlay2-17e05645d70836c66b8113a12cfa21f4a49a8e64c04db752432bd42f7d99c8b0-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/17e05645d70836c66b8113a12cfa21f4a49a8e64c04db752432bd42f7d99c8b0/merged
  var-lib-docker-overlay2-19d7431c89a850fe44b164934c522e0fbf44802118e16433e69e6eb989997137-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/19d7431c89a850fe44b164934c522e0fbf44802118e16433e69e6eb989997137/merged
  var-lib-docker-overlay2-66d4b69b9f5ffe03f85cda088076fb50d6d0cbaf15f6ab3562e8acb9f92feb51-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/66d4b69b9f5ffe03f85cda088076fb50d6d0cbaf15f6ab3562e8acb9f92feb51/merged
  var-lib-docker-overlay2-6956bafabe053a50d166a3d8ea1f0619b50e61455914c70758ec9799b5728d76-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/6956bafabe053a50d166a3d8ea1f0619b50e61455914c70758ec9799b5728d76/merged
  var-lib-docker-overlay2-7ff4e2b16cceceed20434c32b275233a71692e11798b20b4933205153f5eb612-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/7ff4e2b16cceceed20434c32b275233a71692e11798b20b4933205153f5eb612/merged
  var-lib-docker-overlay2-84b3093e8fa38467607c210fd3ad782cbff8fe9f68aac8951313e8521e17bda1-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/84b3093e8fa38467607c210fd3ad782cbff8fe9f68aac8951313e8521e17bda1/merged
  var-lib-docker-overlay2-9d503d0b4bfd3ec259c3fe2fdad8738bdcf09277239e9f055075b3da81a85e97-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/9d503d0b4bfd3ec259c3fe2fdad8738bdcf09277239e9f055075b3da81a85e97/merged
  var-lib-docker-overlay2-9fc19e0a50f2ba30f21ab9e276b9d8ef2dbbd04c1f6195a71c03f973a003fde4-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/9fc19e0a50f2ba30f21ab9e276b9d8ef2dbbd04c1f6195a71c03f973a003fde4/merged
  var-lib-docker-overlay2-ad306957250317836e1fe5e49e96cef7345f01e670ae91fd6b90099399e20f21-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/ad306957250317836e1fe5e49e96cef7345f01e670ae91fd6b90099399e20f21/merged
  var-lib-docker-overlay2-d51ca4df7921532e7ac13e88329dac163ef11e330c7981d568a5bd13a1c23d3e-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/d51ca4df7921532e7ac13e88329dac163ef11e330c7981d568a5bd13a1c23d3e/merged
  var-lib-docker-overlay2-e904919db59cdfd899ac2a0532ebbd24390dbf2bde6e25c1d07b6f9ba818c864-merged.mount                 loaded active mounted   /var/lib/docker/overlay2/e904919db59cdfd899ac2a0532ebbd24390dbf2bde6e25c1d07b6f9ba818c864/merged
  systemd-remount-fs.service                                                                                            loaded active exited    Remount Root and Kernel File Systems 
```

从上面的信息中可以找到挂载任务：opt-aquar-storages-aquarpool.mount

3.找到docker启动任务并备份。

```
cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
```

4.编辑docker启动任务，将第二步中找到的挂载任务设置为他的After项目以及Wants项目。

```
vim /lib/systemd/system/docker.service
```

编辑后docker.service内容如下：

```properties
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service containerd.service opt-aquar-storages-aquarpool.mount
Wants=network-online.target opt-aquar-storages-aquarpool.mount
Requires=docker.socket containerd.service

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H fd:// --containerd=/run/containerd/containerd.sock
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutSec=0
RestartSec=2
Restart=always

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
# Both the old, and new name are accepted by systemd 230 and up, so using the old name to make
# this option work for either version of systemd.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity

# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

# kill only the docker process, not all processes in the cgroup
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
```
5.执行`systemctl daemon-reload`重载系统服务。

6.执行`systemctl enable trunas-scan.service`将脚本设置为开机启动。

7.执行`systemctl status trunas-scan.service`查看服务在loaded那一行是否为enabled。如果是，则代表脚本正常部署了。