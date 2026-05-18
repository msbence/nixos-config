{
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./options.nix
    inputs.preservation.nixosModules.preservation
    inputs.refind-nix.nixosModules.default
  ]
  ++ lib.lists.map (directoryName: ./${directoryName}) (
    builtins.attrNames (
      lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
    )
  );

  nixpkgs.overlays = [
    inputs.refind-nix.overlays.default
  ];
}
