{ config, lib, pkgs, ... }:

{
  programs.hyfetch = {
    enable = true;

    settings = {
      preset = "transgender";
      light_dark = "dark";      
      mode = "rgb";
      
      lightness = {};
      
      color_align = {
        mode = "horizontal";
        custom_colors = [];
        fore_back = null;
      };

      args = null;
      distro = null;
      backend = "fastfetch";
      pride_month_shown = [];
      pride_month_disable = false;
    };
  };
}
