{
  lib,
  config,
  ...
}:
{
  services = {
    pipewire = lib.mkIf config.systemOptions.enableAudio {
      enable = true;
      pulse.enable = true;
      alsa.enable = false;
      jack.enable = false;
    };
  };
}
