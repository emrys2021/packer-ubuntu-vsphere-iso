#* vcenter server 地址及凭据
vsphere_server = "10.15.17.123"
vsphere_username = "administrator@vsphere.local"
vsphere_password = "Qwerty123$"

#* 指定数据中心，esxi节点，数据存储
vsphere_datacenter = "DC01"
vsphere_host = "10.15.17.13"
vsphere_datastore = "datastore3-2"

#* 指定虚拟机名称、操作系统类型、硬件配置、网络，构建完成后是否转换成模板
vsphere_vm_name = "tpl-ubuntu-2004"
vsphere_guest_os_type = "ubuntu64Guest"
vsphere_network = "DPortGroup"
vsphere_network_card = "vmxnet3"

#* 从iso镜像安装系统，指定iso相关路径
os_iso_paths = ["[datastore3-2] iso/ubuntu-20.04.6-live-server-amd64.iso"] # 不从internet下载iso镜像，指定本地iso镜像，并附加cd_content指定的目录到iso镜像挂载目录
os_cd_label = "cidata"
# cloud_init files for unattended configuration for Ubuntu
# cloud_init 指定本地路径，不使用远端路径
cloudinit_userdata = "./http/user-data"
cloudinit_metadata = "./http/meta-data"

#* 指定boot command，使用cloudinit进行自动化安装，指定cloudinit数据源
boot_order       = "disk,cdrom,floppy"
boot_wait        = "3s"
boot_command = [
  "<esc><esc><esc>",
  "<enter><wait>",
  "/casper/vmlinuz ",
  "root=/dev/sr0 ",
  "initrd=/casper/initrd ",
  "autoinstall ",
  "ds=nocloud-net;",
  "<enter>"
]
shutdown_command = "echo 'vagrant' | sudo -S -E shutdown -P now"
shutdown_timeout = "15m"

#* iso镜像安装完系统后，指定使用ssh communicator进行provision
communicator = "ssh"
# SSH username (created in user-data. If you change it here the please also adjust in ./html/user-data)
ssh_username = "vagrant"
# SSH password (created in autounattend.xml. If you change it here the please also adjust in ./html/user-data)
ssh_password = "vagrant"
ssh_timeout = "30m"
ssh_handshake_attempts = "100000"

#* final clean up script
shell_scripts = ["./setup/setup.sh"]



