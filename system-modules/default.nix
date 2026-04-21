{
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./options.nix
    inputs.impermanence.nixosModules.impermanence
  ]
  ++ lib.lists.map (directoryName: ./${directoryName}) (
    builtins.attrNames (
      lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
    )
  );
}
