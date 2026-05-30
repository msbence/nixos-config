{
  lib,
  config,
  pkgs,
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

  environment.systemPackages = lib.mkIf config.systemOptions.enableAudio [
    pkgs.pulseaudio
  ];
}
