{
  inputs,
  lib,
  config,
  pkgs,
  useUnstableChannels,
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
      themeOptions = config.themeOptions;
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

      xdg.portal.config.common.default = "*";

      home = {
        stateVersion = config.userOptions.homeManagerStateVersion;

        username = "${config.userOptions.username}";
        homeDirectory = "/home/${config.userOptions.username}";

        sessionVariables = {
          EDITOR = "nano";
          NH_OS_FLAKE = "/home/${config.userOptions.username}/nixos-config";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";
          XDG_CURRENT_DESKTOP = "Hyprland";
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland";
          SDL_VIDEODRIVER = "wayland,x11";
          _JAVA_AWT_WM_NONREPARENTING = "1";
        };

        packages =
          with pkgs;
          [
            devenv
            awscli2
            ssm-session-manager-plugin
            python3
            ansible-lint
            python313Packages.boto3
            python313Packages.botocore
            python313Packages.awscrt
            pre-commit
            android-tools
            transmission_4-qt
            #
            htop
            nixfmt
            nil
            vivaldi
            playerctl
            slurp
            grim
            swappy
            pavucontrol
            nh
            orca-slicer
            zoxide
            fastfetch
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
            rclone
            remmina
            vlc
            fluffychat
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
            #platformio
            platformio-core
            teensy-loader-cli
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
            virt-manager
            wl-clipboard
            teamspeak6-client
          ]
          ++ lib.optionals (config.systemOptions.hasTouchscreen) [ wvkbd ]
          # packages that are broken on unstable, but at least should have on stable
          ++ lib.optionals (useUnstableChannels == false) [
            pgadmin4
          ];
      };
    };
  };
}
