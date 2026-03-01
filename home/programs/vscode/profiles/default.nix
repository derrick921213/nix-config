{
  pkgs,
  common,
  ...
}: let
  nixProfile = (import ./nix.nix {inherit pkgs common;}).Nix;
  pythonProfile = (import ./python.nix {inherit pkgs common;}).Python;
  rustProfile = (import ./rust.nix {inherit pkgs common;}).Rust;
  phpProfile = (import ./php.nix {inherit pkgs common;}).Php;
in {
  default = {
    extensions =
      common.commonExtensions
      ++ nixProfile.extensions or []
      ++ pythonProfile.extensions or []
      ++ rustProfile.extensions or []
      ++ phpProfile.extensions or [];
    userSettings =
      common.commonUserSettings
      // nixProfile.userSettings or {}
      // pythonProfile.userSettings or {}
      // rustProfile.userSettings or {}
      // phpProfile.userSettings or {};
  };
}
