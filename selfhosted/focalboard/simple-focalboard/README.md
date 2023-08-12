# How to deploy/un-deploy
- Run cd `aws-lab-with-terraform/selfhosted/focalboard/simple-focalboard`
- Init `terraform init`
- Deploy `terraform apply`. Check then confirm by typing `y`
- Once done, run `terraform destroy` to cleanup the resouces and avoid unexpected AWS cost
