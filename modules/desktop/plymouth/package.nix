{
  stdenv,
  lib,
}:
let
  src = ./theme;
in
stdenv.mkDerivation {
  inherit src;

  name = "framework-plymouth-theme";

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/framework
    cp theme/* $out/share/plymouth/themes/framework

    # Fix the hardcoded /usr/ paths to point to the Nix store
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
  '';

  meta = {
    description = "Framework Laptop plymouth boot theme";
    homepage = "https://git.sr.ht/~jameskupke/framework-plymouth-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
