{config, ...}: let
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [
    ./cli.nix
    ./nushell
    ./starship.nix
    ./transient-services.nix
    ./zsh.nix
  ];

  # add environment variables
  home.sessionVariables = {
    # clean up ~
    LESSHISTFILE = cache + "/less/history";
    LESSKEY = c + "/less/lesskey";
    WINEPREFIX = d + "/wine";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    EDITOR = "hx";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };
}
