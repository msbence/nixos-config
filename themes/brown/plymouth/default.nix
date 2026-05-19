{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "brown-plymouth-theme";
  version = "1.0";

  src = ./src;

  installPhase = ''
    runHook preInstall

    themeDir="$out/share/plymouth/themes/brown"
    mkdir -p $themeDir
    cp -r * $themeDir/
    sed -i "s@/usr/share/plymouth/themes/brown@$themeDir@g" $themeDir/brown.plymouth

    runHook postInstall
  '';
}
