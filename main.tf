resource "hcloud_ssh_key" "ephemeral" {
  name       = "ephemeral"
  public_key = file(var.public_key_file)
}

resource "local_file" "nixos_installer" {
  filename = "install-nixos.sh"
  content = templatefile("${path.module}/install-nixos.sh", {
    "nixos_config" : var.nixos_config
    "disko_config" : var.disko_config
  })
}

resource "hcloud_server" "nixos" {
  name = "nixos"

  image       = var.image
  server_type = var.server_type
  location    = var.location

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  ssh_keys = [
    "${hcloud_ssh_key.ephemeral.id}",
  ]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.private_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "DEBIAN_FRONTEND=noninteractive apt-get -y install kexec-tools",
      "curl -L https://github.com/nix-community/nixos-images/releases/download/nixos-unstable/nixos-kexec-installer-x86_64-linux.tar.gz | tar -xzf- -C /root",
      "/root/kexec/run",
      # keep the session open before the machine starts booting into NixOS
      "sleep 6"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /persist"
    ]
  }

  # provisioner "file" {
  #   source      = var.luks_passphrase_file
  #   destination = local.luks_pass_file
  # }

  # provisioner "file" {
  #   content     = <<-TOKEN
  #     CACHIX_AGENT_TOKEN=FOO
  #   TOKEN
  #   destination = local.cachix_agent_token_temp_file
  # }

  provisioner "remote-exec" {
    script = local_file.nixos_installer.filename
  }

  # wait for NixOS to reboot
  provisioner "local-exec" {
    command = "sleep 10"
  }
}
