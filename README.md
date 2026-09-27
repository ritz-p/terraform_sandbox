# Terraform plan reference sandbox

Minimal reproduction of how a resource reference appears as `(known after apply)` in a human-readable plan.

## Requirements

- Docker Engine and Docker Compose v2
- Network access to pull container images and install the AWS provider

Terraform runs inside the pinned `hashicorp/terraform:1.16.4` image. The AWS provider is pinned to `6.66.0`.

```sh
docker compose run --rm terraform init
docker compose run --rm terraform version
docker compose run --rm terraform plan
```

In the plan, `aws_security_group.example.vpc_id` appears as `(known after apply)` although `main.tf` sets it to `aws_vpc.example.id`. The initial plan uses dummy credentials and does not require LocalStack or contact AWS. To save the plan for an issue reproduction:

```sh
docker compose run --rm terraform plan -out=plan.tfplan
docker compose run --rm terraform show plan.tfplan
```

Do not commit plan files or state files; they may contain sensitive values and are ignored by Git. After `init`, commit `.terraform.lock.hcl` if using this sandbox for ongoing work.

## Optional local apply

LocalStack is optional for the initial plan. Current LocalStack images require an Auth Token. Supply your own token through the shell, then start LocalStack:

```sh
export LOCALSTACK_AUTH_TOKEN='your-token'
docker compose --profile localstack up -d localstack
docker compose run --rm terraform apply
```

Terraform's EC2 endpoint points at `http://localstack:4566`. The configuration is intended for local use only. Clean up before stopping the emulator:

```sh
docker compose run --rm terraform destroy
docker compose --profile localstack down
```
