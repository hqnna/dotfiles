{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = "[](#2a2a2a)$directory[](fg:#2a2a2a bg:#4a4a4a)$git_branch[](fg:#4a4a4a bg:#6a6a6a)\${custom.jj}[](#6a6a6a) ";
      
      scan_timeout = 60;
      command_timeout = 3600;
      add_newline = false;

      directory = {
        truncate_to_repo = false;
        format = "[󰉋 $path ](bg:#2a2a2a fg:#FFFFFF)";
      };

      git_branch = {
        format = "[ 󰘬 $branch ](bg:#4a4a4a fg:#FFFFFF)";
      };

      custom.jj = {
        format = "[ 󰅐 $output ](bg:#6a6a6a fg:#FFFFFF)";
        command = "jj log -r@ -n1 --ignore-working-copy --no-graph --color never -T 'change_id.short(7)'";
        when = "jj root";
      };
    };
  };
}
