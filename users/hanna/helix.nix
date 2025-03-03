{ config, lib, pkgs, ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "base16_transparent";

      editor = {
        scrolloff = 0;
        mouse = false;
        scroll-lines = 5;
        line-number = "absolute";
        auto-completion = false;
        auto-format = false;
        auto-info = false;
      };

      editor.lsp = {
        enable = false;
      };

      editor.cursor-shape = {
        select = "block";
        normal = "bar";
        insert = "bar";
      };
    };
  };
}
