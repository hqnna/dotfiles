{ config, lib, pkgs, ... }:

{
  xdg.enable = true;
  xdg.dataHome = "${config.home.homeDirectory}/.local/share";
  xdg.stateHome = "${config.home.homeDirectory}/.local/state";
  xdg.configHome = "${config.home.homeDirectory}/.config";
  xdg.cacheHome = "${config.home.homeDirectory}/.cache";
}
