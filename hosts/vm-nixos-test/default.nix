{ nixpkgs, inputs, ... }:
let
  # TODO: use defaults and override as needed
  systemProperties = {
    architecture = "x86_64-linux";
    hostname = builtins.baseNameOf ./. ;
    type = "server"; # or desktop
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
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    inputs.impermanence.nixosModules.impermanence
    ./configuration.nix
    ../../system-modules/default.nix
    inputs.home-manager.nixosModules.home-manager
    ../../user-modules/default.nix
    ./overrides.nix
  ];
}
