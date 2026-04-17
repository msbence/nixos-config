{
  nixpkgs,
  inputs,
  nixos-hardware,
  ...
}:
let
  systemProperties = {
    architecture = "x86_64-linux";
    hostname = builtins.baseNameOf ./.;
    type = "desktop";
    stateVersion = "25.11";
  };

  userProperties = rec {
    username = "raptor";
    fullName = "Bence Madarasz";
    emailUser = "msbence.kfg";
    emailDomain = "gmail.com";
    email = "${emailUser}@${emailDomain}"; # less food for scrapers
    homeManagerStateVersion = "25.11";
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
    { system.stateVersion = systemProperties.stateVersion; }
    ./hardware-configuration.nix
    #nixos-hardware.nixosModules.framework-13th-gen-intel
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    ../../system-modules/default.nix
    ../../user-modules/default.nix
    ./overrides.nix
  ];
}
