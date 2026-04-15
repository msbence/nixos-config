{ nixpkgs, inputs, nixos-hardware, ... }:
let
  systemProperties = {
    architecture = "x86_64-linux";
    hostname = builtins.baseNameOf ./. ;
    type = "desktop";
  };

  userProperties = rec {
    username = "raptor";
    fullName = "Bence Madarasz";
    emailUser = "msbence.kfg";
    emailDomain = "gmail.com";
    email = "${emailUser}@${emailDomain}"; # less food for scrapers
  };
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
    inherit systemProperties;
    inherit userProperties;
  };

  system = systemProperties.architecture;

  modules = [
    ./hardware-configuration.nix
    #nixos-hardware.nixosModules.framework-13th-gen-intel
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    ./configuration.nix
    ../../system-modules/default.nix
    ../../user-modules/default.nix
    ./overrides.nix
  ];
}
