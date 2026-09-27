# Terraform sandbox

A workspace for experimenting with Terraform configurations and checking provider behavior. Terraform runs in Docker, and [kumo](https://github.com/sivchari/kumo) emulates supported AWS APIs locally.

## Requirements

- Docker Engine and Docker Compose v2
- Network access to pull container images and install providers

Terraform is pinned to 1.16.4 and the AWS provider to 6.66.0. The local AWS emulator is kumo v0.28.1. Terraform uses dummy credentials and points EC2 requests at kumo; it does not use a real AWS account.

## Run the example

```sh
docker compose up -d kumo
docker compose run --rm terraform init
docker compose run --rm terraform version
docker compose run --rm terraform plan
docker compose run --rm terraform apply
```

The current example creates a VPC and a security group. The security group's `vpc_id` is configured as `aws_vpc.example.id`, but an initial human-readable plan shows `(known after apply)`. This makes the configuration useful for examining how Terraform displays unknown resource references.

To save the exact plan for review:

```sh
docker compose run --rm terraform plan -out=plan.tfplan
docker compose run --rm terraform show plan.tfplan
```

Run `docker compose run --rm terraform destroy` before `docker compose down` to remove the example resources. kumo's state persists in the `kumo-data` Docker volume across restarts. Removing that volume while keeping Terraform's state can cause them to diverge.

Plan and state files can contain sensitive data and are ignored by Git. After `init`, commit `.terraform.lock.hcl` when continuing to develop this repository. As new experiments are added, configure each AWS service endpoint to point at `http://kumo:4566`.
