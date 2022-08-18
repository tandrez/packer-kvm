
variable "config_file" {
  type    = string
  default = "rhel8-kickstart.cfg"
}

variable "cpu" {
  type    = string
  default = "2"
}

variable "destination_server" {
  type    = string
  default = "download.goffinet.org"
}

variable "disk_size" {
  type    = string
  default = "10000"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:8cb0dfacc94b789933253d5583a2fb7afce26d38d75be7c204975fe20b7bdf71"
}

variable "iso_url" {
  type    = string
  default = "/iso/rhel-8.6-x86_64-dvd.iso"
}

variable "name" {
  type    = string
  default = "rhel"
}

variable "ram" {
  type    = string
  default = "2048"
}

variable "ssh_password" {
  type    = string
  default = "testtest"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "version" {
  type    = string
  default = "8"
}

source "qemu" "rhel8" {
  accelerator      = "kvm"
  boot_command     = ["<up><wait><tab><wait> net.ifnames=0 biosdevname=0 text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/${var.config_file}<enter><wait>"]
  boot_wait        = "40s"
  disk_cache       = "none"
  disk_compression = true
  disk_discard     = "unmap"
  disk_interface   = "virtio"
  disk_size        = var.disk_size
  format           = "qcow2"
  headless         = var.headless
  http_directory   = "."
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  net_device       = "virtio-net"
  output_directory = "artifacts/qemu/${var.name}${var.version}"
  qemu_binary      = "/usr/bin/qemu-system-x86_64"
  qemuargs         = [["-m", "${var.ram}M"], ["-smp", "${var.cpu}"]]
  shutdown_command = "sudo /usr/sbin/shutdown -h now"
  ssh_password     = var.ssh_password
  ssh_username     = var.ssh_username
  ssh_wait_timeout = "30m"
}

build {
  sources = ["source.qemu.rhel8"]
}
