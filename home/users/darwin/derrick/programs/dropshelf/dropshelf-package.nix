{
  stdenv,
  lib,
  unzip,
}:
stdenv.mkDerivation {
  pname = "dropshelf";
  version = "1729";

  src = ./Dropshelf-build-1729.zip;

  nativeBuildInputs = [unzip];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -R *.app $out/Applications/
  '';

  meta = with lib; {
    platforms = platforms.darwin;
  };
}
