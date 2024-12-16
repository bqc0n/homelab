variable "template" {
  type = string
}

variable "ssh_keys" {
  type = string
}

variable "hosts" {
  type = list(object({
    cores    = number,
    hostname = string,
    node     = string,
    ipv4     = string,
  }))
}

variable "specs" {
  type = object({
    sockets = number,
    memory  = number,
    storage = string,
    size    = string,
    bridge  = string,
  })
}

variable "vmid_start" {
  type = number
}

variable "gateway" {
  type = string
}

variable "nameserver" {
  type = string
}