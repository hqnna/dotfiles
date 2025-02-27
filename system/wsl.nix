{ config, lib, pkgs, ... }:

{
  wsl = {
    enable = true;
    defaultUser = "hanna";
    interop.register = true;
    startMenuLaunchers = true;
    useWindowsDriver = true;

    wslConf.network = {
      generateResolvConf = false;
    };
  };
}
