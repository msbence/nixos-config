{
  config,
  ...
}:
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
      * {
        background-image: none;
        box-shadow: none;
      }
      window {
        background-color: rgba(0, 0, 0, 0.6);
      }
      button {
        margin-top: 25em;
        margin-bottom: 25em;
        border-radius: 20px;
        background-color: #${config.lib.stylix.colors.base00};
      }
      button:focus, button:active, button:hover {
        border-radius: 20px;
        outline-style: none;
        border: none;
        background-color: #${config.lib.stylix.colors.base02};
      }
      button label {
        margin-bottom: 4em; /* wlogout is a pretty unmaintained piece of ...art. */
      }
    '';
  };
}
