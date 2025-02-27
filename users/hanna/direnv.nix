{ config, lib, pkgs, ... }:

{
  programs.direnv = {
    nix-direnv.enable = true;
    enableZshIntegration = true;
    config.warn_timeout = "1h";
    silent = true;
    enable = true;
  };
}
