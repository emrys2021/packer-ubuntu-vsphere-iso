packer {
  required_plugins {
    vsphere = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

# vcenter server 地址及凭据
variable "vsphere_server" {
  type    = string
  default = ""
}

variable "vsphere_username" {
  type    = string
  default = ""
}

variable "vsphere_password" {
  type      = string
  default   = ""
  sensitive = true
}

# 指定数据中心，esxi节点，数据存储，网络
variable "vsphere_datacenter" {
  type    = string
  default = ""
}

variable "vsphere_host" {
  type    = string
  default = ""
}

variable "vsphere_datastore" {
  type    = string
  default = ""
}

variable "vsphere_network" {
  type    = string
  default = "DPortGroup"  # 这里配置default的值不知道为什么不生效，需要在vars文件指定
}

# 指定虚拟机名称，操作系统类型，硬件配置
variable "vsphere_vm_name" {
  type    = string
  default = ""
}

variable "vsphere_guest_os_type" {
  type    = string
  default = ""
}

variable "cpu_num" {
  type    = number
  default = 2
}

variable "mem_size" {
  type    = number
  default = 2048
}

variable "disk_size" {
  type    = number
  default = 51200
}

# 从iso镜像安装系统，指定iso相关路径
variable "os_iso_checksum" {
  type    = string
  default = ""
}

variable "os_iso_url" {
  type    = string
  default = ""
}

# 使用cloudinit进行自动化安装，指定cloudinit数据源
variable "boot_command" {
  type        = list(string)
  description = "Ubuntu boot command"
  default     = []
}

variable "cloudinit_userdata" {
  type    = string
  default = ""
}

variable "cloudinit_metadata" {
  type    = string
  default = ""
}

# iso镜像安装完系统后，指定使用ssh communicator进行provision
variable "ssh_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "ssh_username" {
  type    = string
  default = ""
}

variable "shell_scripts" {
  type        = list(string)
  description = "A list of scripts."
  default     = []
}

source "vsphere-iso" "ubuntu" {

  # vcenter server 地址及凭据
  vcenter_server      = var.vsphere_server
  username            = var.vsphere_username
  password            = var.vsphere_password
  insecure_connection = "true"

  # 指定数据中心，esxi节点，数据存储，网络
  datacenter = var.vsphere_datacenter
  host       = var.vsphere_host
  datastore  = var.vsphere_datastore

  # 指定虚拟机名称，操作系统类型，硬件配置，构建完成后是否转换成模板
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

  network_adapters {
    network      = var.vsphere_network
    network_card = "vmxnet3"
  }

  convert_to_template = "true"

  # 从iso镜像安装系统，指定iso相关路径
  // iso_checksum          = var.os_iso_checksum
  // iso_url               = var.os_iso_url
  iso_paths = ["[datastore3-2] iso/ubuntu-20.04.6-live-server-amd64.iso"] # 不从internet下载iso镜像，指定本地iso镜像，并附加cd_content指定的目录到iso镜像挂载目录
  cd_content = {
    "/meta-data" = file("${var.cloudinit_metadata}")
    "/user-data" = file("${var.cloudinit_userdata}")
  }
  cd_label = "cidata"

  # 使用cloudinit进行自动化安装，指定cloudinit数据源
  boot_order       = "disk,cdrom,floppy"
  boot_wait        = "3s"
  boot_command     = var.boot_command
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "15m"

  configuration_parameters = {
    "disk.EnableUUID" = "true"
  }

  # iso镜像安装完系统后，指定使用ssh communicator进行provision
  communicator           = "ssh"
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_timeout            = "30m"
  ssh_handshake_attempts = "100000"
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
