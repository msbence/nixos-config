{ pkgs, userProperties, ... }:
{
  users.users.${userProperties.username} = {
    isNormalUser = true;
    hashedPassword = "$6$1QJS.s3YyMOb8P9T$4/udjDW7RTOQD/SrxPIDihKD1T.2R6kOHOUSFZxhgg376.apJaGkWECkRU5WIhm6B2XC/M8sshRDwvLDckkuz0";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "kvm"
      "adbusers"
      "docker"
      "wireshark"
      "fwupd"
      "cups"
      "libvirtd"
    ];
    packages = with pkgs; [
      htop
      nixfmt-rfc-style
    ];
  };
}
