{ ... }:
{
  programs = {
    nix-ld.enable = true;
  };

  services = {
    envfs.enable = false;  # TODO: fixme
  };
}
