#* vcenter server 地址及凭据
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

#* 指定数据中心，esxi节点，数据存储
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

#* 指定虚拟机名称、操作系统类型、硬件配置、网络，构建完成后是否转换成模板
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

variable "vsphere_network" {
  type    = string
  default = ""
}

variable "vsphere_network_card" {
  type    = string
  default = ""
}

#* 从iso镜像安装系统，指定iso相关路径
variable "os_iso_checksum" {
  type    = string
  default = ""
}

variable "os_iso_url" {
  type    = string
  default = ""
}

variable "os_iso_paths" {
  type    = list(string)
  default = []
}

variable "os_cd_label" {
  type    = string
  default = ""
}

variable "cloudinit_userdata" {
  type    = string
  default = ""
}

variable "cloudinit_metadata" {
  type    = string
  default = ""
}

#* 指定boot command，使用cloudinit进行自动化安装，指定cloudinit数据源
variable "boot_order" {
  type        = string
  default     = ""
}

variable "boot_wait" {
  type        = string
  default     = ""
}

variable "boot_command" {
  type        = list(string)
  description = "Ubuntu boot command"
  default     = []
}

variable "shutdown_command" {
  type        = string
  default     = ""
}

variable "shutdown_timeout" {
  type        = string
  default     = ""
}

#* iso镜像安装完系统后，指定使用ssh communicator进行provision
variable "communicator" {
  type      = string
  default   = ""
}

variable "ssh_username" {
  type    = string
  default = ""
}

variable "ssh_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "ssh_timeout" {
  type      = string
  default   = ""
}

variable "ssh_handshake_attempts" {
  type      = string
  default   = ""
}

variable "shell_scripts" {
  type        = list(string)
  description = "A list of scripts."
  default     = []
}