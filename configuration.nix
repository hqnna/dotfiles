{ config, lib, pkgs, ... }:

{
  imports = [
    ./services/podman.nix
    ./system/environment.nix
    ./system/networking.nix
    ./system/settings.nix
    ./system/security.nix
    ./system/locale.nix
    ./system/users.nix
    ./system/wsl.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  system.stateVersion = "24.11";
}
