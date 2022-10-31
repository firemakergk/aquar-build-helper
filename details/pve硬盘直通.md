## 硬盘直通

1.在pve的shell控制台中执行`ls -l /dev/disk/by-id/`命令，列出所有硬盘设备的id及其对应的磁盘简称，执行后结果格式如下所示。其中ata-开头代表使用的是sata接口，此外还有scs、nvme等类型。

```
root@pve:~# ls -l /dev/disk/by-id/
total 0
lrwxrwxrwx 1 root root  9 Apr  3 09:59 ata-HGST_HUS724040ALA640_PN1334PCJLA9MS -> ../../sda
lrwxrwxrwx 1 root root 10 Apr  3 09:59 ata-HGST_HUS724040ALA640_PN1334PCJLA9MS-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Apr  3 09:59 ata-HGST_HUS724040ALA640_PN1334PCJLA9MS-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 Apr  3 09:59 ata-HGST_HUS724040ALA640_PN1334PCK2EUES -> ../../sdb
lrwxrwxrwx 1 root root  9 Apr  3 09:59 ata-INTEL_SSDSC2BA400G3_BTTV510004YG400HGN -> ../../sde
lrwxrwxrwx 1 root root 10 Apr  3 09:59 ata-INTEL_SSDSC2BA400G3_BTTV510004YG400HGN-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Apr  3 09:59 ata-INTEL_SSDSC2BA400G3_BTTV510004YG400HGN-part2 -> ../../sde2
lrwxrwxrwx 1 root root 10 Apr  3 09:59 ata-INTEL_SSDSC2BA400G3_BTTV510004YG400HGN-part3 -> ../../sde3
```

2.找到想要直通的硬盘，拷贝id全文，如“ata-HGST\_HUS724040ALA640\_PN1334PCJLA9MS”

3.按照如下格式执行语句，将这个设备直通给某个虚拟机。

```
qm set <vm_id> –<disk_type>[n] /dev/disk/by-id/<type>-$brand-$model_$serial_number
```

例如我想把“ata-...JLA9MS”这块硬盘直通给id为101的虚拟机，执行的语句是：

```
qm set 101 -scsi2 /dev/disk/by-id/ata-HGST_HUS724040ALA640_PN1334PCJLA9MS
```

其中qm set是命令，101就是虚拟机的id，-scsi2指的是使用scis模式直通，且其通道编号是scsi2，每个虚拟机建立出来以后给他挂载的系统盘编号通常是xxx0，如sata0、scsi0等，新挂载的硬盘编号只要不与这台虚拟机上已有的编号重复即可。执行完以后如果一切正常，控制台会返回一个提示：“update VM ...”，具体如下所示：

```
root@pve:~# qm set 101 -scsi2 /dev/disk/by-id/ata-HGST_HUS724040ALA640_PN1334PCJLA9MS
update VM 101: -scsi2 /dev/disk/by-id/ata-HGST_HUS724040ALA640_PN1334PCJLA9MS
```

4.这时候打开虚拟机的管理页就可以看到有一块新的硬盘出现在设备列表中，但颜色是橙色的，表示还没有生效，这时重启这台虚拟机就可以使其生效了。