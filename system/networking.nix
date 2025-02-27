{ config, lib, pkgs, ... }:

{
  networking = {
    hostId = "f897cbb3";
    hostName = "amethyst";
    firewall.enable = false;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    timeServers = [ "time.cloudflare.com" ];
  };
}
