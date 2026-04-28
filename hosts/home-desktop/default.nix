{
  inputs,
  ...
}:
let
  systemArchitecture = "x86_64-linux";
  useUnstableChannels = false;

  active-nixpkgs = if useUnstableChannels then inputs.nixpkgs-unstable else inputs.nixpkgs;
  active-home-manager =
    if useUnstableChannels then inputs.home-manager-unstable else inputs.home-manager;
in
active-nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs systemArchitecture active-home-manager;
    hostname = builtins.baseNameOf ./.;
  };

  system = systemArchitecture;

  modules = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    ../../user-modules/options.nix
    ../../system-modules/default.nix
    ../../user-modules/default.nix
    ./settings.nix
  ];
}
