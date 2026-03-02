{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    keyutils
  ];

  services.samba = {
    enable = true;
    securityType = "ads";
    extraConfig = ''
      workgroup = MAY-GOD
      realm = MAY-GOD.COM
      netbios name = NIXOS-0281

      idmap config * : backend = tdb
      idmap config * : range = 3000-7999
      idmap config MAY-GOD : backend = rid
      idmap config MAY-GOD : range = 10000-999999
      client signing = yes
      client use spnego = yes
      kerberos method = secrets and keytab
    '';
  };
  services.samba-wsdd.enable = true;
  networking.nameservers = ["192.168.0.10"];
  networking.search = ["may-god.com"];
}
