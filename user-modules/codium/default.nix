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
      njpwerner.autodocstring
      oderwat.indent-rainbow
      pkief.material-icon-theme
      redhat.ansible
      redhat.vscode-xml
      redhat.vscode-yaml
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
