{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "blue-plymouth-theme";
  version = "1.0";

  src = ./src; 

  installPhase = ''
    runHook preInstall

    themeDir="$out/share/plymouth/themes/blue"
    mkdir -p $themeDir
    cp -r * $themeDir/
    sed -i "s@/usr/share/plymouth/themes/blue@$themeDir@g" $themeDir/blue.plymouth

    runHook postInstall
  '';
}
