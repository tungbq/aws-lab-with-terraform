resource "null_resource" "local_debug" {
  provisioner "local-exec" {
    command = <<EOT
      date
      df -h  
      echo "This is multi command mode"
      ls -la 
      echo "Done!"
    EOT
  }
}
