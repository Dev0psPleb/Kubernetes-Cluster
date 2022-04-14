output "master_ip" {
  value = module.master.ip
}

output "worker_ip" {
  value = module.worker.ip
}

output "kube_config" {
  value = filebase64("../ansible/.kube/config")
}