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

check:
    nix flake check --show-trace --all-systems

ssh:
    ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i .ssh_ephemeral_id_rsa root@78.46.248.230

    # $(tofu output -raw server_ipv4)
