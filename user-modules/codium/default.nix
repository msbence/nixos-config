{ pkgs, ... }:
{
  programs.vscodium = {
    enable = true;

    profiles.default.enableUpdateCheck = false;
    mutableExtensionsDir = false;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      eamodio.gitlens
      editorconfig.editorconfig
      formulahendry.auto-rename-tag
      foxundermoon.shell-format
      gitlab.gitlab-workflow
      hashicorp.terraform
      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools
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

      (ms-vscode.cpptools.overrideAttrs (old: rec {
        version = "1.24.4"; # fuck you Microsoft :)
        src = pkgs.fetchurl {
          url = "https://github.com/microsoft/vscode-cpptools/releases/download/v${version}/cpptools-linux-x64.vsix";
          hash = "sha256-OWd0a3VWp+myUayosdJdZg8614s0KvNUP82XPG4J03o=";
        };
      }))
      # Nix
      jnoortheen.nix-ide
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
