{ config, lib, pkgs, ... }:

{
  xdg.configFile."npm/npmrc" = {
    enable = true;
    text = lib.generators.toKeyValue {} {
      prefix = "${config.xdg.dataHome}/npm";
      cache = "${config.xdg.cacheHome}/npm";
      init-module = "${config.xdg.configHome}/npm/config/npm-init.js";
      state-dir = "${config.xdg.stateHome}/pnpm-state";
      store-dir = "${config.xdg.dataHome}/pnpm-store";
      tmp = "${config.xdg.cacheHome}/npm";
    };
  };
}
