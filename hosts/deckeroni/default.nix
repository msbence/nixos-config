{
  inputs,
  ...
}:
let
  systemArchitecture = "x86_64-linux";
  useUnstableChannels = true;

  active-nixpkgs = if useUnstableChannels then inputs.nixpkgs-unstable else inputs.nixpkgs;
  active-home-manager =
    if useUnstableChannels then inputs.home-manager-unstable else inputs.home-manager;
  active-stylix = if useUnstableChannels then inputs.stylix-unstable else inputs.stylix;
in
active-nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit
      inputs
      systemArchitecture
      active-home-manager
      active-stylix
      ;
    hostname = builtins.baseNameOf ./.;
  };

  system = systemArchitecture;

  modules = [
    ./hardware-configuration.nix
    inputs.jovian-nixos.nixosModules.jovian
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    ../../user-modules/options.nix
    ../../themes/default.nix
    ../../system-modules/default.nix
    ../../user-modules/default.nix
    ./settings.nix
  ];
}
