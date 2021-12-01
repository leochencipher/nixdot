{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # kernel
  #boot.extraModulePackages = with config.boot.kernelPackages; [ anbox ];
  boot.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPatches = [
    {
      name = "amd_pmc";
      patch = ../../pkgs/amd_pmc.patch;
      extraConfig = "";
    }
  ];
  # supposedly conserves battery
  boot.kernelParams = [ "nmi_watchdog=0" ];

  # bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  boot.plymouth.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = [ "sap" ];
      hsphfpd.enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
    };

    cpu.amd.updateMicrocode = true;

    enableAllFirmware = true;

    opentabletdriver.enable = true;
  };

  networking.hostName = "io";

  nix.buildMachines = lib.mkForce [ ];

  programs = {
    adb.enable = true;
    light.enable = true;
    steam.enable = true;
  };

  services = {
    blueman.enable = true;

    btrfs.autoScrub.enable = true;

    clight = {
      enable = true;
      settings = {
        backlight = {
          ## Transition step in percentage
          trans_step = 0.05;

          ## Transition timeout in ms
          trans_timeout = 1000;

          ## Timeouts between captures during day/night/event on AC
          ## Set any of these to <= 0 to disable captures
          ## in the corresponding day time.
          ac_timeouts = [ 60 300 300 ];

          ## Timeouts between captures during day/night/event on BATT
          ## Set any of these to <= 0 to disable captures
          ## in the corresponding day time.
          batt_timeouts = [ 60 300 300 ];

          pause_on_lid_closed = true;
          capture_on_lid_opened = true;
        };

        gamma = {
          long_transition = true;
        };

        sensor.devname = "iio:device0";

        dimmer.timeouts = [ 600 300 ];
      };
    };

    kmonad.configfiles = [ ./main.kbd ];

    # keep logs around
    journald.extraConfig = lib.mkForce "";

    pipewire.lowLatency.enable = true;

    #power-profiles-daemon.enable = false;

    printing.enable = true;

    ratbagd.enable = true;

    #tlp = {
    #  enable = true;
    #  settings = {
    #    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #    CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
    #  };
    #};

    udev.extraRules = ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
    '';

    xserver = {
      videoDrivers = [ "amdgpu" ];

      displayManager.session = [
        {
          manage = "window";
          name = "Wayfire";
          start = "exec $HOME/.wl-session";
        }
      ];
    };
  };

  virtualisation.waydroid.enable = true;
}
