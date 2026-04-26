{ ... }:
{
  programs = {
    nix-ld.enable = true;
  };

  services = {
    envfs.enable = false;  # TODO: investigate why this fails on fresh install when true
  };
}
