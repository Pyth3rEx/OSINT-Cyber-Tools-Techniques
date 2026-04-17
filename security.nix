{ config, pkgs, ... }:

{
  # Sudo
  security.sudo.wheelNeedsPassword = true;

  # Polkit
  security.polkit.enable = true;

  # Disable coredumps
  systemd.coredump.enable = false;

  # SSH hardening (disabled by default, enable when needed)
  services.openssh.enable = false;
}
