provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = var.insecure // false for vRA Cloud and true for vRA 8.0
}

data "vra_region_enumeration" "dc_regions" {
  username = var.username
  password = var.password
  hostname = var.hostname
  dcid     = ""
}

resource "vra_cloud_account_vsphere" "vcsa" {
  name        = "vcsa-01a.corp.local"
  description = "OneCloud VCSA"
  username    = var.username
  password    = var.password
  hostname    = var.hostname
  regions     = ["Datacenter:datacenter-141"]
  #regions                 = data.vra_region_enumeration.dc_regions.regions
  accept_self_signed_cert = true

  tags {
    key   = "env"
    value = "vsphere"
  }
}
