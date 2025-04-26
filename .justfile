set dotenv-load

# list targets
help:
  @just --list

# list images on hetzner
images:
    hcloud image list --output columns=id,name,type,labels


# terraform/opentofu

init:
    tofu init

plan:
    tofu plan -var-file=.env.tfvars

apply:
    tofu apply -auto-approve -var-file=.env.tfvars

destroy:
    tofu destroy -var-file=.env.tfvars
