{
  inputs,
  lib,
  config,
  pkgs,
  active-home-manager,
  active-stylix,
  ...
}:
{
  imports = [
    active-home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      systemOptions = config.systemOptions;
      userOptions = config.userOptions;
    };

    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";

    users.${config.userOptions.username} = {
      imports = [
        ./options.nix
        inputs.hyprdynamicmonitors.homeManagerModules.default
        active-stylix.homeModules.stylix
      ]
      ++ lib.lists.map (directoryName: ./${directoryName}) (
        builtins.attrNames (
          lib.attrsets.filterAttrs (name: type: type == "directory") (builtins.readDir ./.)
        )
      );

      programs.home-manager.enable = true;
      programs.bash.enable = true; # required for working home session envvars

      home = {
        stateVersion = config.userOptions.homeManagerStateVersion;

        username = "${config.userOptions.username}";
        homeDirectory = "/home/${config.userOptions.username}";

        sessionVariables = {
          EDITOR = "nano";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";
          XDG_CURRENT_DESKTOP = "Hyprland";
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland";
          SDL_VIDEODRIVER = "wayland";
          _JAVA_AWT_WM_NONREPARENTING = "1";
        };

        packages = with pkgs; [
          htop
          nixfmt-rfc-style
          nil
          vivaldi
          unstable.hyprlauncher
          slurp
          grim
          swappy
          #
          tree
          nautilus
          nemo
          gns3-gui
          colorls
          bat
          xcp
          ansible
          ansible-lint
          pylint
          yamllint
          fzf
          kubectl
          kubectx
          fluxcd
          terraform
          opentofu
          tofu-ls
          file
          vault
          pulsemixer
          slack
          xdg-desktop-portal-wlr
          gimp
          k9s
          openrgb
          pgadmin4
          rclone
          remmina
          vlc
          element-desktop
          jq
          yq
          velero
          google-cloud-sdk
          unzip
          p7zip
          stu
          speedtest-cli
          inetutils
          nmap
          shellcheck
          dmidecode
          ethtool
          pwgen
          usbutils
          minikube
          kubernetes-helm
          terraform-docs
          s3cmd
          imagemagick
          minicom
          adoptopenjdk-icedtea-web
          hex
          packer
          expect
          gettext
          anydesk
        ];
      };
    };
  };
}
