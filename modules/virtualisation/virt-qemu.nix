{user,...}:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;   # KVM optimized build
      ovmf.enable = true;        # UEFI support
      ovmf.packages = [ pkgs.OVMF.fd ];
      swtpm.enable = true;       # TPM support (Win11 etc.)
    };
  };

  programs.virt-manager.enable = true;

  users.users.${user}.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtiofsd
  ];

  # optional: enable USB redirection & SPICE
  services.spice-vdagentd.enable = true;
}
