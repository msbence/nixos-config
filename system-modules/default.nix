{
  inputs,
  lib,
  systemProperties,
  userProperties,
  ...
}:
{
  imports =
    lib.lists.map (directoryName: ./${directoryName}) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
      )
    )
    ++ [
      inputs.impermanence.nixosModules.impermanence
      ./options.nix
    ];
}
