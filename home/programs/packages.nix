{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # office
    libreoffice

    # messaging
    tdesktop
    # let discord open links
    xdg-utils
    # torrents
    transmission-remote-gtk

    # misc
    libnotify

    # productivity
    taskwarrior
    timewarrior
  ];
}
