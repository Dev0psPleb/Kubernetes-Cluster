output "master_ip" {
  value = module.master.ip
}

output "worker_ip" {
  value = module.worker.ip
}

output "default_gateway" {
  value = local.default_gateway
}