resource "null_resource" "this" {
    depends_on          = [var.module]
    dynamic  "file_provisioner" {
        for_each = var.file_provisioner == 
    }
}