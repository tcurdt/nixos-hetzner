{
  # config,
  # pkgs,
  # lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # boot.growPartition = true;
  boot.loader.grub = {
    # device gets set by disko
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # boot.initrd.availableKernelModules = [
  #   "ata_piix"
  #   "uhci_hcd"
  #   "xen_blkfront"
  #   "vmw_pvscsi"
  # ];
  # boot.initrd.kernelModules = [ "nvme" ];

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # fileSystems."/" = {
  #   device = "/dev/sda1";
  #   fsType = "ext4";
  # };

  # services.cloud-init = {
  #   enabled = true;
  #   network.enable = true;
  # };

}
