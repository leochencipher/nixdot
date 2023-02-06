{
  config,
  pkgs,
  inputs,
  ...
} @ args: {
  imports = [./hardware-configuration.nix];

  boot = {
    initrd = {
      systemd.enable = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 20;
    };

    plymouth.enable = true;
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  hardware = {
    bluetooth = {
      enable = true;
      # battery info support
      package = pkgs.bluez5-experimental;
      settings = {
        # make Xbox Series X controller work
        General = {
          Class = "0x000100";
          ControllerMode = "bredr";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
          Experimental = true;
        };
      };
    };
    enableRedistributableFirmware = true;

    opentabletdriver.enable = true;
    xpadneo.enable = true;
  };

  networking.networkmanager.enable = true;
  networking.hostName = "gramnix";

  programs = {
    # enable hyprland and required options
    hyprland.enable = true;

    # backlight control
    light.enable = true;

    steam.enable = true;

    nm-applet.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services = {
    # use Ambient Light Sensors for auto brightness adjustment
    clight = {
      enable = true;
      settings = {
        verbose = true;
        dpms.timeouts = [300 180];
        dimmer.timeouts = [290 170];
      };
    };

    # for SSD/NVME
    fstrim.enable = true;

    printing.enable = true;

    # configure mice
    ratbagd.enable = true;

    # power saving
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
        NMI_WATCHDOG = 0;
      };
    };

    udev.extraRules = let
      inherit (import ./plugged.nix args) plugged unplugged;
    in ''
      # add my android device to adbusers
      SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"

      # start/stop services on power (un)plug
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${plugged}"
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${unplugged}"
    '';

    # add hyprland to display manager sessions
    xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.hostPlatform.system}.default];
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
