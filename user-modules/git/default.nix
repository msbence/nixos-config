{ pkgs, userProperties, ... }:
{
  programs.git = {
    enable = true;
    user.name = userProperties.fullName;
    user.email = userProperties.email;
    package = pkgs.git;

    signing = {
      key = "2928 40BC 9898 2B6F FFB7  F4BC 6DA3 A9F8 6933 73A0";
      signByDefault = true;
    };

    ignores = [
      ".DS_Store"
      "venv/"
    ];
  };
}
