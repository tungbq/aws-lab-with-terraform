resource "null_resource" "local_debug" {
  provisioner "local-exec" {
    command = "date"
  }
}
