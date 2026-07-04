{
  config,
  ...
}:
{
  services = {
    elephant = {
      enable = true;
      settings = {
        providers = {
          default = [
            "desktopapplications"
            "runner"
            "calc"
            "clipboard"
            "symbols"
          ];
        };
      };
    };

    walker = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme = "default";
        hide_quick_activation = true;
        hide_action_hints = true;
        providers = {
          default = [
            "desktopapplications"
            "runner"
            "calc"
            "clipboard"
            "symbols"
          ];
          prefixes = [
            {
              provider = "desktopapplications";
              prefix = "";
            }
            {
              provider = "runner";
              prefix = ">";
            }
            {
              provider = "calc";
              prefix = "=";
            }
            {
              provider = "clipboard";
              prefix = "<";
            }
            {
              provider = "symbols";
              prefix = ".";
            }
          ];
        };
      };

      theme = {
        name = "default";
        style = ''
          @define-color window_bg_color #${config.lib.stylix.colors.base01}DD;
          @define-color accent_bg_color #${config.lib.stylix.colors.base02};
          @define-color theme_fg_color #${config.lib.stylix.colors.base0D};

          * {
            all: unset;
          }

          popover,
          .box-wrapper {
            background: @window_bg_color;
            padding: 5px;
            border-radius: 20px;
            border: 2px solid @theme_fg_color;
          }

          .search-container {
            margin-bottom: 10px;
          }

          .input {
            background: transparent;
            padding: 10px 5px;
            color: @theme_fg_color;
            caret-color: @theme_fg_color;
          }

          .input placeholder {
            opacity: 0.5;
          }

          .list {
            border-spacing: 8px;
            color: @theme_fg_color;
          }

          .item-box {
            padding: 10px 5px;
            border-radius: 14px;
          }

          .item-subtext {
            opacity: 0.32;
          }

          child:selected .item-box,
          row:selected .item-box {
            background: @accent_bg_color;
          }
        '';
      };
    };
  };

  # soooooo ugly, but a centered VPN menu is even worse
  xdg.configFile."walker/themes/topright-menu/style.css".text = ''
    @define-color window_bg_color #${config.lib.stylix.colors.base01}DD;
    @define-color accent_bg_color #${config.lib.stylix.colors.base02};
    @define-color theme_fg_color #${config.lib.stylix.colors.base0D};

    * { all: unset; }

    popover, .box-wrapper {
      background: @window_bg_color;
      padding: 5px;
      border-radius: 14px;
      border: 2px solid @theme_fg_color;
    }

    .list { border-spacing: 4px; color: @theme_fg_color; }
    .item-box { padding: 10px; border-radius: 10px; }
    child:selected .item-box, row:selected .item-box { background: @accent_bg_color; }
  '';

  xdg.configFile."walker/themes/topright-menu/layout.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <requires lib="gtk" version="4.0"></requires>
      <object class="GtkWindow" id="Window">
        <style>
          <class name="window"></class>
        </style>
        <property name="resizable">true</property>
        <property name="title">Walker</property>
        <child>
          <object class="GtkBox" id="BoxWrapper">
            <style>
              <class name="box-wrapper"></class>
            </style>
            <property name="overflow">hidden</property>
            <property name="orientation">horizontal</property>
            <property name="valign">start</property>
            <property name="halign">end</property>
            <property name="width-request">200</property>
            <property name="height-request">250</property>
            <child>
              <object class="GtkBox" id="Box">
                <style>
                  <class name="box"></class>
                </style>
                <property name="orientation">vertical</property>
                <property name="hexpand-set">true</property>
                <property name="hexpand">true</property>
                <property name="spacing">10</property>
                <child>
                  <object class="GtkBox" id="SearchContainer">
                    <style>
                      <class name="search-container"></class>
                    </style>
                    <property name="overflow">hidden</property>
                    <property name="orientation">horizontal</property>
                    <property name="halign">fill</property>
                    <property name="hexpand-set">true</property>
                    <property name="hexpand">true</property>
                    <child>
                      <object class="GtkEntry" id="Input">
                        <style>
                          <class name="input"></class>
                        </style>
                        <property name="halign">fill</property>
                        <property name="hexpand-set">true</property>
                        <property name="hexpand">true</property>
                      </object>
                    </child>
                  </object>
                </child>
                <child>
                  <object class="GtkBox" id="ContentContainer">
                    <style>
                      <class name="content-container"></class>
                    </style>
                    <property name="orientation">horizontal</property>
                    <property name="spacing">10</property>
                    <child>
                      <object class="GtkLabel" id="ElephantHint">
                        <style>
                          <class name="elephant-hint"></class>
                        </style>
                        <property name="label">Waiting for elephant...</property>
                        <property name="hexpand">true</property>
                        <property name="vexpand">true</property>
                        <property name="visible">false</property>
                        <property name="valign">0.5</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkLabel" id="Placeholder">
                        <style>
                          <class name="placeholder"></class>
                        </style>
                        <property name="label">No Results</property>
                        <property name="hexpand">true</property>
                        <property name="vexpand">true</property>
                        <property name="valign">0.5</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkScrolledWindow" id="Scroll">
                        <style>
                          <class name="scroll"></class>
                        </style>
                        <property name="can_focus">false</property>
                        <property name="overlay-scrolling">true</property>
                        <property name="hexpand">true</property>
                        <property name="vexpand">true</property>
                        <property name="max-content-width">500</property>
                        <property name="min-content-width">500</property>
                        <property name="max-content-height">400</property>
                        <property name="propagate-natural-height">true</property>
                        <property name="propagate-natural-width">true</property>
                        <property name="hscrollbar-policy">automatic</property>
                        <property name="vscrollbar-policy">automatic</property>
                        <child>
                          <object class="GtkGridView" id="List">
                            <style>
                              <class name="list"></class>
                            </style>
                            <property name="max_columns">1</property>
                            <property name="min_columns">1</property>
                            <property name="can_focus">false</property>
                          </object>
                        </child>
                      </object>
                    </child>
                    <child>
                      <object class="GtkBox" id="Preview">
                        <style>
                          <class name="preview"></class>
                        </style>
                      </object>
                    </child>
                  </object>
                </child>
                <child>
                  <object class="GtkBox" id="Keybinds">
                    <property name="hexpand">true</property>
                    <property name="margin-top">10</property>
                    <style>
                      <class name="keybinds"></class>
                    </style>
                    <child>
                      <object class="GtkBox" id="GlobalKeybinds">
                        <property name="spacing">10</property>
                        <style>
                          <class name="global-keybinds"></class>
                        </style>
                      </object>
                    </child>
                    <child>
                      <object class="GtkBox" id="ItemKeybinds">
                        <property name="hexpand">true</property>
                        <property name="halign">end</property>
                        <property name="spacing">10</property>
                        <style>
                          <class name="item-keybinds"></class>
                        </style>
                      </object>
                    </child>
                  </object>
                </child>
                <child>
                  <object class="GtkLabel" id="Error">
                    <style>
                      <class name="error"></class>
                    </style>
                    <property name="xalign">0</property>
                    <property name="visible">false</property>
                  </object>
                </child>
              </object>
            </child>
          </object>
        </child>
      </object>
    </interface>
  '';
}
