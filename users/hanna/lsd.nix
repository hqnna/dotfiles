{ config, lib, pkgs, ... }:

{
  programs.lsd = {
    enable = true;
    enableAliases = true;

    settings = {
      classic = false;
      blocks = [ "permission" "user" "group" "date" "size" "name" ];
      color = { when = "always"; };
      icons = { when = "never"; };
      symlink-arrow = "󰁔";
      size = "short";
    };
  };
}
