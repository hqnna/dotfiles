{ config, lib, pkgs, ... }:

{
  programs.hyfetch = {
    enable = true;

    settings = {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = {
      };
      color_align = {
        mode = "horizontal";
        custom_colors = [

        ];
        fore_back = null;
      };
      backend = "fastfetch";
      args = null;
      distro = null;
      pride_month_shown = [

      ];
      pride_month_disable = false;
    };
  };
}
