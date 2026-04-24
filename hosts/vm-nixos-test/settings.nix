{ ... }:
{
  systemOptions.systemStateVersion = "25.11";
  userOptions.homeManagerStateVersion = "25.11";

  systemOptions.deviceType = "desktop";

  systemOptions.enableFingerprint = true;
  systemOptions.enableFirewall = false;
  systemOptions.powerManagementProfile = {
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";

    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 90;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 75;
  };
  systemOptions.enableSsh = true;
}
