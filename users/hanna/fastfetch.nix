{ config, lib, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        separator = " → ";
        constants = [
          "┌──────────────────────────────────┐"
          "└──────────────────────────────────┘"
        ];
      };

      modules = [
        {
          type = "title";
          format = "{#blue}{user-name}{#reset_}@{#blue}{host-name}";
        }
        {
          type = "custom";
          format = "{#blue}{$1}";
        }
        {
          type = "os";
          key = "  {#blue} Distro";
          format = "{pretty-name}";
        }
        {
          type = "kernel";
          key = "  {#blue} Kernel";
          format = "{release}";
        }
        {
          type = "packages";
          key = "  {#blue} Packages";
          format = "{#blue} S: {#white}{nix-system}{#blue}  U: {#white}{nix-user}";
        }
        {
          type = "custom";
          format = "{#blue}{$2}";
        }
        {
          type = "custom";
          format = "{#magenta}{$1}";
        }
        {
          type = "de";
          key = "  {#magenta} Desktop";
          format = "{pretty-name} {version}";
        }
        {
          type = "wm";
          key = "  {#magenta} Manager";
          format = "{pretty-name} ({protocol-name})";
        }
        {
          type = "terminal";
          key = "  {#magenta} Terminal";
          format = "{process-name} {version}";
        }
        {
          type = "custom";
          format = "{#magenta}{$2}";
        }
        {
          type = "custom";
          format = "{#yellow}{$1}";
        }
        {
          type = "cpu";
          key = "  {#yellow} CPU";
          format = "{name}";
        }
        {
          type = "memory";
          key = "  {#yellow} Memory";
          format = "{used} / {total}";
        }
        {
          type = "disk";
          key = "  {#yellow} Storage";
          format = "{size-used} / {size-total}";
        }
        {
          type = "display";
          key = "  {#yellow}󰍹 Display";
          format = "{width}x{height} @ {refresh-rate} Hz";
        }
        {
          type = "custom";
          format = "{#yellow}{$2}";
        }
        {
          type = "colors";
          symbol = "square";
          key = "  {#yellow} Colors";
        }
      ];
    };
  };
}
