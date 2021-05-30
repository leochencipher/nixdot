# home server configuration
{ config, lib, pkgs, agenix, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  age.secrets = {
    ddclientConfig.file = ../../secrets/ddclientConfig.age;
    mailPass.file = ../../secrets/mailPass.age;
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # network
  networking = {
    hostName = "homesv";
    interfaces.enp3s0.useDHCP = true;
    interfaces.wlp2s0.useDHCP = true;
    wireless.iwd.enable = true;
  };
  networking.firewall = { allowedTCPPorts = [ 80 443 ]; };

  # don't suspend when lid is closed
  services.logind.lidSwitch = "ignore";

  services.journald.extraConfig = lib.mkForce "";

  users.users = {
    user.isNormalUser = true;
    server = {
      isSystemUser = true;
      group = "server";
      extraGroups = [ "render" ];
    };
  };
}
