{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home/shell.nix
    ../../modules/home/git.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
