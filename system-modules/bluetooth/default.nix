{ ... }:
{
  hardware = {
    bluetooth = {
      enable = false;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };

  services = {
    blueman.enable = true;
  };
}
