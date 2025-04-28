resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "${path.module}/.ssh_ephemeral_id_rsa"
  file_permission = "0600"
}

resource "hcloud_ssh_key" "ephemeral" {
  name       = "ephemeral-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

locals {
  nixos_installer_content = templatefile("${path.module}/install-nixos.sh", {
    nixos_config = var.nixos_config
    disko_config = var.disko_config
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
  ssh_keys = [hcloud_ssh_key.ephemeral.id]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = tls_private_key.ssh.private_key_pem
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

  provisioner "remote-exec" {
    inline = [local.nixos_installer_content]
  }

  # wait for reboot
  provisioner "local-exec" {
    command = "sleep 10"
  }

  provisioner "file" {
    # source = var.foo
    content     = <<-TOKEN
      FOO
    TOKEN
    destination = "/root/foo"
  }

  provisioner "remote-exec" {
    inline = [
      "whoami",
      "cat /root/foo || true",
      "shutdown -h now"
    ]
  }
}

resource "hcloud_snapshot" "nixos" {
  depends_on  = [hcloud_server.nixos]
  server_id   = hcloud_server.nixos.id
  description = "NixOS server snapshot"
  labels = {
    name    = "base"
    type    = var.server_type
    version = "nixos-24.11"
  }
}

output "snapshot_id" {
  description = "ID of the snapshot"
  value       = hcloud_snapshot.nixos.id
}

output "server_ipv4" {
  description = "IPv4 address"
  value       = hcloud_server.nixos.ipv4_address
}

output "server_ipv6" {
  description = "IPv6 address"
  value       = hcloud_server.nixos.ipv6_address
}
