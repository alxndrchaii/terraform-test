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
    source = "github.com/ajaibid/devops-terraform-modules.git//gcp/compute-engine/vm-instances?ref=v2.5.8"
  }
  
  inputs = {
    count_compute = 2 #number ie 2
  
    service_name = "keydb-${include.resource.locals.service_name}"
    compute_type = "e2-highcpu-2"
    ip_forward   = false
    image_name   = "projects/ajaib-dev-coin/global/images/base-image-keydb-4"
  
    subnetwork         = "subnet-${include.project.locals.environment_short}-${include.resource.locals.region_prefix}-coin" #string alpaca
    subnetwork_project = include.resource.locals.project_subnetwork
  
    size_root_disk = 15 #number ie 2
    type_root_disk = "pd-balanced" #string ie pd-balanced or standard
  
    labels = {
      prometheus_alert  = true
      prometheus_scrape = true
      created_by        = "terraform"
      environment       = include.project.locals.environment
      environment_short = include.project.locals.environment_short
      host_target       = include.resource.locals.service_name
      healthcheck_group = "none"
      service_group     = "coin" #string ie alpaca
      service_type      = "redis" #string ie redis
      service_name      = include.resource.locals.service_name
      region            = include.region.locals.region
      project_id        = include.project.locals.project_id
    }
  
    tags = [
      include.project.locals.environment,
      include.resource.locals.service_name,
      "terraform",
      # custom tags
      # allowing tags
      "allow-exporter",
      "allow-internet",
      "allow-ssh",
      "redis",
      "keydb"
    ]
  }