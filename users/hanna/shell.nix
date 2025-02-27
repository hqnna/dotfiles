{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    completionInit = ''
      autoload -U compinit
      mkdir -p ${config.xdg.stateHome}/zsh
      compinit -d ${config.xdg.stateHome}/zsh/completion
    '';

    dirHashes = {
      win = "/mnt/c/Users/Hanna";
    };

    shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
    };

    sessionVariables = {
      # XDG Standard Directories
      XDG_DATA_HOME = config.xdg.dataHome;
      XDG_STATE_HOME = config.xdg.stateHome;
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_CACHE_HOME = config.xdg.cacheHome;

      # Software Directory Paths
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_history";
      SQLITE_HISTORY = "${config.xdg.stateHome}/sqlite_history";
      OLLAMA_MODELS = "${config.xdg.dataHome}/ollama/models";
      LESSHISTFILE = "${config.xdg.stateHome}/less_history";
      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/cuda";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      GOPATH = "${config.xdg.dataHome}/golang";

      # Environment Variables
      PODMAN_IGNORE_CGROUPSV1_WARNING = "1";
      COLORTERM = "truecolor";
      EDITOR = "hx";
    };

    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      share = true; 
      size = 10000;
      save = 1000;
    };

    antidote = {
      enable = true;

      plugins = [
        "zdharma-continuum/fast-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
      ];
    };
  };
}
