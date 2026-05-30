{
  config,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      #cd = "z";
      #cdi = "zi";
      #cp = "xcp";
      #cat = "bat -P";
      #ls = "colorls";
      venva = "source venv/bin/activate";
      venvc = "python3 -m venv venv";
      code = "${pkgs.vscodium}/bin/codium";
    };
    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "ansible"
        "colorize"
        "docker"
        "kubectl"
        "kubectx"
        "python"
        "virtualenv"
      ];
      theme = "agnoster";
      extraConfig = ''
        zstyle ':omz:alpha:lib:git' async-prompt no
        ZSH_CUSTOM=${config.home.homeDirectory}/.zsh-themes

        #source ${config.home.homeDirectory}/nixos-config/home-packages/zsh/secrets.env
        #eval "$(${config.home.homeDirectory}/nixos-config/home-packages/kubectl/setup_env.sh)"

        export PATH=$PATH:${config.home.homeDirectory}/.bin
      '';
    };
  };
}
