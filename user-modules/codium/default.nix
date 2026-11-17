{ pkgs, ... }:
let
  slint-wrapped = pkgs.symlinkJoin {
    name = "slint-wrapped";
    paths = [
      pkgs.slint-lsp
      pkgs.slint-viewer
    ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      # Inject Wayland, XKB, and OpenGL/EGL libraries, plus the NixOS hardware driver path
      wrapProgram $out/bin/slint-lsp \
        --prefix LD_LIBRARY_PATH : ${
          pkgs.lib.makeLibraryPath (
            with pkgs;
            [
              wayland
              libxkbcommon
              libglvnd
            ]
          )
        }:/run/opengl-driver/lib
      wrapProgram $out/bin/slint-viewer \
        --prefix LD_LIBRARY_PATH : ${
          pkgs.lib.makeLibraryPath (
            with pkgs;
            [
              wayland
              libxkbcommon
              libglvnd
            ]
          )
        }:/run/opengl-driver/lib
    '';
  };
in
{
  home.packages = [ slint-wrapped ];

  programs.vscodium = {
    enable = true;

    profiles.default.enableUpdateCheck = false;
    mutableExtensionsDir = false;

    profiles.default.extensions =
      with pkgs.vscode-extensions;
      [
        eamodio.gitlens
        editorconfig.editorconfig
        formulahendry.auto-rename-tag
        foxundermoon.shell-format
        gitlab.gitlab-workflow
        hashicorp.terraform
        ms-azuretools.vscode-docker
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-python-envs
        njpwerner.autodocstring
        oderwat.indent-rainbow
        pkief.material-icon-theme
        redhat.ansible
        redhat.vscode-xml
        redhat.vscode-yaml
        platformio.platformio-vscode-ide

        ((pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "Slint";
          publisher = "Slint";
          version = "1.16.1";
          sha256 = "whai8bvL+IJdeKe4/AFFQJ3bXrLvg7Ui8CGWpIbZpf8=";
        }).overrideAttrs
        (old: {
          postPatch = ''
            rm -f bin/slint-lsp*
            ln -s ${slint-wrapped}/bin/slint-lsp bin/slint-lsp-x86_64-unknown-linux-gnu
          '';
        }))

        (ms-vscode.cpptools.overrideAttrs (old: rec {
          version = "1.24.4"; # fuck you Microsoft :)
          src = pkgs.fetchurl {
            url = "https://github.com/microsoft/vscode-cpptools/releases/download/v${version}/cpptools-linux-x64.vsix";
            hash = "sha256-OWd0a3VWp+myUayosdJdZg8614s0KvNUP82XPG4J03o=";
          };
        }))
        # Nix
        jnoortheen.nix-ide
      ]
      ++ [
        pkgs.unstable.vscode-extensions.saoudrizwan.claude-dev # Cline
      ];

    profiles.default.userSettings = {
      # Updates - VS Code
      "update.mode" = "none";
      # Updates - VS Code Extensions
      "extensions.autoUpdate" = false;
      # Tracking
      "telemetry.telemetryLevel" = "off";
      # Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };
      #
      "workbench.iconTheme" = "material-icon-theme";
      "redhat.telemetry.enabled" = false;
      "explorer.confirmDelete" = false;
      "files.autoSave" = "afterDelay";
      "security.workspace.trust.untrustedFiles" = "open";
      "yaml.customTags" = [ "!reference sequence" ];
      "autoDocstring.docstringFormat" = "numpy";
      "editor.tabSize" = 4;
      "editor.insertFinalNewline" = true;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = false;
      "git.confirmSync" = false;
    };
  };
}
