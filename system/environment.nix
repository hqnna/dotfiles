{ config, lib, pkgs, ... }:

{
  programs = {
    zsh.enable = true;
    zsh.enableGlobalCompInit = false;
    zsh.vteIntegration = true;
    gnupg.agent.enable = true;
    nix-ld.enable = true;
  };

  environment = {
    localBinInPath = true;
    memoryAllocator.provider = "scudo";
    defaultPackages = with pkgs; [
      unzip
      helix
      wget
      zip
    ];
  };
}
