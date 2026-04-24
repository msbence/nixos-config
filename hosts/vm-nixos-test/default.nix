{
  nixpkgs,
  inputs,
  ...
}:
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
    hostname = builtins.baseNameOf ./.;
  };

  system = "x86_64-linux";

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
