{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    iterm2
    just
  ];
}
