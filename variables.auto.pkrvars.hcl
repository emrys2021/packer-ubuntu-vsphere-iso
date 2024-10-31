# Name or IP of you vCenter Server
vsphere_server = "10.15.17.123"

# vsphere username
vsphere_username = "administrator@vsphere.local"

# vsphere password
vsphere_password = "Qwerty123$"

# vsphere datacenter name
vsphere_datacenter = "DC01"

# name or IP of the ESXi host
vsphere_host = "10.15.17.13"

# vsphere network
vsphere_network = "DPortGroup"

# vsphere datastore
vsphere_datastore = "datastore3-2"

# guest_os_type
vsphere_guest_os_type = "ubuntu64Guest"

# cloud_init files for unattended configuration for Ubuntu
# cloud_init 指定本地路径，不使用远端路径
cloudinit_userdata = "./http/user-data"
cloudinit_metadata = "./http/meta-data"

# final clean up script
shell_scripts = ["./setup/setup.sh"]

# SSH username (created in user-data. If you change it here the please also adjust in ./html/user-data)
ssh_username = "vagrant"

# SSH password (created in autounattend.xml. If you change it here the please also adjust in ./html/user-data)
ssh_password = "vagrant"
