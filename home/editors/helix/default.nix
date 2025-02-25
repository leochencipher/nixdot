{
  inputs,
  pkgs,
  ...
} @ args: {
  home.packages = [pkgs.shellcheck];

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.hostPlatform.system}.default;

    languages = import ./languages.nix args;

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        true-color = true;
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          rainbow = "dim";
        };
        rainbow-brackets = true;
        statusline.center = ["position-percentage"];
      };

      keys.normal.space.u = {
        f = ":format"; # format using LSP formatter
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };
  };
}
