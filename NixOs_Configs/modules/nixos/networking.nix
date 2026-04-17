{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Disable mDNS hostname broadcasting (OPSEC)
  services.avahi.enable = false;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };
}
