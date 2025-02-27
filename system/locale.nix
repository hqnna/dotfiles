{ config, lib, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/New_York";
}
