include {
  path = find_in_parent_folders()
}

include "project" {
  path   = find_in_parent_folders("project.hcl")
  expose = true
}

include "provider" {
  path   = find_in_parent_folders("provider.hcl")
  expose = true
}

include "region" {
  path   = find_in_parent_folders("region.hcl")
  expose = true
}

include "resource" {
  path   = find_in_parent_folders("resource.hcl")
  expose = true
}

terraform {
  source = "github.com/"
}

inputs = {
  count_compute = 2

  service_name = "keydb-${include.resource.locals.service_name}"
  compute_type = ""
  ip_forward   = false
  image_name   = ""

  subnetwork         = "subnet-${include.project.locals.environment_short}-${include.resource.locals.region_prefix}-alpaca"
  subnetwork_project = include.resource.locals.project_subnetwork

  size_root_disk = 15
  type_root_disk = "pd-standard"

  labels = {
    prometheus_alert  = true
    prometheus_scrape = true
    created_by        = "terraform"
    environment       = include.project.locals.environment
    environment_short = include.project.locals.environment_short
    host_target       = include.resource.locals.service_name
    healthcheck_group = "none"
    service_group     = "sss"
    service_type      = "redis"
    service_name      = include.resource.locals.service_name
    region            = include.region.locals.region
    project_id        = include.project.locals.project_id
  }

  tags = [
    include.project.locals.environment
  ]
}