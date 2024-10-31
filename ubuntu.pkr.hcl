packer {
  required_plugins {
    vsphere = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

source "vsphere-iso" "ubuntu" {

  #* vcenter server 地址及凭据
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_username
  password            = var.vsphere_password
  insecure_connection = "true"

  #* 指定数据中心，esxi节点，数据存储
  datacenter = var.vsphere_datacenter
  host       = var.vsphere_host
  datastore  = var.vsphere_datastore

  #* 指定虚拟机名称、操作系统类型、硬件配置、网络，构建完成后是否转换成模板
  vm_name              = var.vsphere_vm_name
  guest_os_type        = var.vsphere_guest_os_type
  CPUs                 = var.cpu_num
  RAM                  = var.mem_size
  RAM_reserve_all      = true
  disk_controller_type = ["pvscsi"]
  storage {
    disk_size             = var.disk_size
    disk_thin_provisioned = true
  }
  configuration_parameters = {
    "disk.EnableUUID" = "true"
  }
  network_adapters {
    network      = var.vsphere_network
    network_card = var.vsphere_network_card
  }
  convert_to_template = "true"

  #* 从iso镜像安装系统，指定iso相关路径，挂载cd目录
  #  iso_checksum          = var.os_iso_checksum
  #  iso_url               = var.os_iso_url
  # iso_paths = ["[datastore3-2] iso/ubuntu-20.04.6-live-server-amd64.iso"] # 不从internet下载iso镜像，指定本地iso镜像，并附加cd_content指定的目录到iso镜像挂载目录
  iso_paths = var.os_iso_paths
  cd_content = {
    "/meta-data" = file("${var.cloudinit_metadata}")
    "/user-data" = file("${var.cloudinit_userdata}")
  }
  # cd_label = "cidata"
  cd_label = var.os_cd_label

  #* 指定boot command，使用cloudinit进行自动化安装，指定cloudinit数据源
  # boot_order       = "disk,cdrom,floppy"
  boot_order       = var.boot_order
  # boot_wait        = "3s"
  boot_wait        = var.boot_wait
  boot_command     = var.boot_command
  # shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_command = var.shutdown_command
  # shutdown_timeout = "15m"
  shutdown_timeout = var.shutdown_timeout

  #* iso镜像安装完系统后，指定使用ssh communicator进行provision
  communicator           = var.communicator
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_timeout            = var.ssh_timeout
  ssh_handshake_attempts = var.ssh_handshake_attempts
}

build {
  sources = ["source.vsphere-iso.ubuntu"]
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    environment_vars = [
      "BUILD_USERNAME=${var.ssh_username}",
    ]
    scripts           = var.shell_scripts
    expect_disconnect = true
  }

}
