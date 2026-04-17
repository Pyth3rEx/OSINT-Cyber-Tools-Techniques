{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/networking.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS encryption
  boot.initrd.luks.devices = {
    "luks-root" = {
      device = "/dev/disk/by-uuid/REPLACE-WITH-ROOT-UUID";
      preLVM = true;
    };
    "luks-swap" = {
      device = "/dev/disk/by-uuid/REPLACE-WITH-SWAP-UUID";
      preLVM = true;
    };
  };

  networking.hostName = "DESKTOP-K7M2PQR";

  # Timezone and locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.bash;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.11";
}
