{ config, lib, pkgs, ... }:

{
  nix = {
    gc.automatic = true;
    gc.dates = "weekly";
    optimise.automatic = true;
    optimise.dates = [ "daily" ];

    settings.cores = 16;
    settings.max-jobs = 32;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
  };
}
