{
  imports = [
    ../../editors/helix
    ../../editors/neovim
    ../../programs
    ../../programs/dunst.nix
    ../../wayland
    ../../terminals/alacritty.nix
    ../../terminals/wezterm.nix
  ];

  services = {
    kanshi = {
      # use 1.6 scaling: 2560 : 1.6 = 1600, exact division. good for offsets
      # restart eww every time because it won't expand/contract automatically
      enable = true;
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
            }
          ];
        };
        docked-all = {
          outputs = [
            {
              criteria = "eDP-1";
              position = "1366,0";
            }
            {
              criteria = "DP-1";
              position = "0,0";
            }
            {
              criteria = "DP-2";
              position = "1600,0";
            }
          ];
        };

        docked1 = {
          outputs = [
            {
              criteria = "eDP-1";
              position = "1366,0";
            }
            {
              criteria = "DP-1";
              position = "0,0";
            }
          ];
        };

        docked2 = {
          outputs = [
            {
              criteria = "eDP-1";
              position = "1366,0";
            }
            {
              criteria = "DP-2";
              position = "0,0";
            }
          ];
        };
      };
      systemdTarget = "graphical-session.target";
    };
  };
}
