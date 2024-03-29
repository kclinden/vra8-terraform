provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = var.insecure // false for vRA Cloud and true for vRA 8.0
}

data "vra_region" "this" {
  cloud_account_id = vra_cloud_account_vsphere.vcsa.id
  region           = var.region
}

resource "vra_cloud_account_vsphere" "vcsa" {
  name        = "vcsa-01a.corp.local"
  description = "OneCloud VCSA"
  username    = var.username
  password    = var.password
  hostname    = var.hostname
  regions     = [var.region]
  #regions    = data.vra_region_enumeration.dc_regions.regions
  accept_self_signed_cert = true

  tags {
    key   = "env"
    value = "vsphere"
  }
}

resource "vra_zone" "onecloud_zone" {
  name      = "OneCloud Zone"
  region_id = data.vra_region.this.id
}

resource "vra_project" "OneCloud_Project" {
  name        = "OneCloud Project"
  description = "OneCloud Project"
  depends_on  = [vra_zone.onecloud_zone]

  zone_assignments {
    zone_id  = vra_zone.onecloud_zone.id
    priority = 1
  }
} 

resource "vra_flavor_profile" "this" {
  name        = "vsphere-flavor-profile"
  description = "Created by vRA provider for Terraform."
  region_id   = data.vra_region.this.id

  flavor_mapping {
    name      = "small"
    cpu_count = 1
    memory    = 1024
  }

  flavor_mapping {
    name      = "medium"
    cpu_count = 2
    memory    = 2048
  }

  flavor_mapping {
    name      = "large"
    cpu_count = 4
    memory    = 4096
  }
}