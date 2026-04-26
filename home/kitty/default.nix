{
  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font Mono";
      size = 10; 
    };

    shellIntegration.enableFishIntegration = true;

    settings = {
      confirm_os_window_close = 0;
      term = "xterm-256color";

      background_opacity = 1;
      background_blur = 0;

      window_padding_width = 5;

      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };

    # Carbonfox color scheme
    extraConfig = ''
      # The basic colors
      background #161616
      foreground #f2f4f8
      selection_background #353535
      selection_foreground #f2f4f8

      # Cursor colors (uncomment for reverse background)
      # cursor none
      cursor #f2f4f8

      # URL underline color when hovering with mouse
      url_color #25be6a

      # Kitty window border colors
      active_border_color #78a9ff
      inactive_border_color #484848
      bell_border_color #3ddbd9

      # Tab bar colors
      active_tab_background #78a9ff
      active_tab_foreground #161616
      inactive_tab_background #353535
      inactive_tab_foreground #7b7c7e
      #tab_bar_background #11111B

      # Normal colors
      color0 #252525
      color1 #ee5396
      color2 #25be6a
      color3 #08bdba
      color4 #78a9ff
      color5 #be95ff
      color6 #33b1ff
      color7 #e4e4e5

      # Bright colors
      color8 #484848
      color9 #ff7eb6
      color10 #3ddbd9
      color11 #33b1ff
      color12 #8cb6ff
      color13 #c8a5ff
      color14 #52bdff
      color15 #f2f4f8

      # Extended colors
      color16 #08bdba
      color17 #ff7eb6
    '';

  };

}