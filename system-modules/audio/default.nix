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
      alsa.enable = true;
      jack.enable = false;
      wireplumber.enable = true;
    };
  };

  environment.systemPackages = lib.mkIf config.systemOptions.enableAudio [
    pkgs.pulseaudio
  ];
}
