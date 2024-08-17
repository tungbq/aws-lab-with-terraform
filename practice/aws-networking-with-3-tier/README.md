# AWS networking with 3 tier web app

## Prepare

Create your own terraform.tfvars file:

```bash
cp terraform.tfvars.sample terraform.tfvars
```

## TF init

```bash
terraform init
```

## TF plan out

```bash
terraform plan -out="tfplan.out"
```

## TF apply

```bash
terraform apply "tfplan.out"
```

## Troubleshooting

- https://stackoverflow.com/questions/31569910/terraform-throws-groupname-cannot-be-used-with-the-parameter-subnet-or-vpc-se
