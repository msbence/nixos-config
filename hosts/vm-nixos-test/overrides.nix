{ lib, inputs, ... }:
with lib;
{
  services.fprintd.enable = mkForce true;
  networking.firewall.enable = mkForce false;
  services.tlp.settings = mkForce {
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 90;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 75;
  };
  services.openssh.enable = mkForce true;
}
