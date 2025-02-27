{ config, lib, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "hanna";
        email = "hanna@hanna.lol";
      };

      signing = {
        key = "F47491837959F4D2";
        sign-all = true;
        backend = "gpg";
      };

      ui = {
        conflict-marker-style = "snapshot";
        default-command = [ "status" ];
        diff.format = "git";
        editor = "hx";
      };

      templates.log_node = ''
        coalesce(
          if(!self, label("elided", "▪")),
          if(current_working_copy, "●"),
          if(immutable, "⊗", "○"),
        )
      '';

      template-aliases = {
        "format_short_id(id)" = ''id.shortest(7).prefix() ++ "[" ++ id.shortest(7).rest() ++ "]"'';
        "format_short_signature(signature)" = ''signature.username()'';
        "format_timestamp(timestamp)" = ''timestamp.ago()'';

        builtin_log_compact = ''
          concat(
            format_short_id(change_id),
            " " ++ separate(" ", format_short_signature(author), local_bookmarks),
            " " ++ coalesce(description, label(if(empty, "empty"), description_placeholder)),
          )
        '';
      };

      git = {
        push-bookmark-prefix = "hanna/";
        private-commits = "description(glob:'local:*')";
      };
    };
  };
}
