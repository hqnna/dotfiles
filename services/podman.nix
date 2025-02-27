{ config, lib, pkgs, ... }:

{
  environment.etc."containers/registries.conf" = lib.mkForce {
    text = "unqualified-search-registries = ['docker.io', 'ghcr.io', 'quay.io']";
    enable = true;
  };

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.dates = "weekly";
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };
}
