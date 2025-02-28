{ config, lib, pkgs, ... }:

{
  users.users.hanna = {
    home = "/home/hanna";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  home-manager.users.hanna = {
    imports = [
      ./fastfetch.nix
      ./starship.nix
      ./hyfetch.nix
      ./direnv.nix
      ./helix.nix
      ./shell.nix
      ./btop.nix
      ./git.nix
      ./lsd.nix
      ./npm.nix
      ./xdg.nix
      ./jj.nix
    ];

    home.username = "hanna";
    home.homeDirectory = "/home/hanna";
    home.stateVersion = "24.11";

    home.packages = with pkgs; [
      podman
      git
      age
    ];
  };
}
