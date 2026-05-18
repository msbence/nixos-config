{
  lib,
  ...
}:
{
  imports = [
    ./options.nix
  ]
  ++ lib.lists.map (directoryName: ./${directoryName}) (
    builtins.attrNames (
      lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
    )
  );
}
