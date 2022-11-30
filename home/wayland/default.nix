{
  pkgs,
  lib,
  config,
  default,
  ...
}:
# Wayland config
let
  _ = lib.getExe;

  # use OCR and copy to clipboard
  ocrScript = let
    inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
  in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';
in {
  imports = [
    ../graphical/eww
    ./hyprland
    ./sway.nix
    ./swaybg.nix
  ];

  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # idle/lock
    swaybg
    swaylock-effects

    # utils
    ocrScript
    wl-clipboard
    wlr-randr
    wlogout
    wofi
  ];

  # make stuff work on wayland
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  programs = {
    obs-studio.plugins = with pkgs.obs-studio-plugins; [wlrobs];

    swaylock.settings = let
      inherit (default) xcolors;
    in {
      clock = true;
      effect-blur = "30x3";
      font = "Roboto";
      ignore-empty-password = true;
      image = default.wallpaper;
      indicator = true;
      bs-hl-color = xcolors.red;
      key-hl-color = xcolors.peach;
      inside-clear-color = xcolors.red;
      inside-color = xcolors.yellow;
      inside-ver-color = xcolors.blue;
      inside-wrong-color = xcolors.red;
      line-color = xcolors.crust;
      ring-color = xcolors.base;
      separator-color = xcolors.subtext1;
    };
  };

  # enable blue light tinting
  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
    };
  };

  # fake a tray to let apps start
  # https://github.com/nix-community/home-manager/issues/2064
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };
}
