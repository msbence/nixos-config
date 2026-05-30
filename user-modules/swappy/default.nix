{ lib, config, ... }:
{
  xdg.configFile."swappy/config".text = lib.generators.toINI { } {
    Default = {
      save_dir = "${config.home.homeDirectory}/screenshots";
      save_filename_format = "${config.userOptions.username}-%Y%m%d-%H%M%S.png";
      show_panel = true;
      line_size = 5;
      text_size = 20;
      text_font = "sans-serif";
      paint_mode = "brush";
      early_exit = true;
      fill_shape = false;
    };
  };
}
