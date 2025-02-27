{ config, lib, pkgs, ... }:

{
  security = {
    doas.enable = true;
    doas.wheelNeedsPassword = false;
    chromiumSuidSandbox.enable = true;
    sudo.enable = false;
    tpm2.enable = true;
  };
}
