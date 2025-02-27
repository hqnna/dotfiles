{ config, lib, pkgs, ... }:

{
  imports = [
    ./system/environment.nix
    ./system/networking.nix
    ./system/settings.nix
    ./system/security.nix
    ./system/locale.nix
    ./system/users.nix
    ./system/wsl.nix
  ];

  system.stateVersion = "24.11";
}
