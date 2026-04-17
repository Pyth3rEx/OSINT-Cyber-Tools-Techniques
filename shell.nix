{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      gs = "git status";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#DESKTOP-K7M2PQR";
      upgrade = "sudo nixos-rebuild switch --flake /etc/nixos#DESKTOP-K7M2PQR --upgrade";
    };
    bashrcExtra = ''
      export EDITOR="kate"
      export VISUAL="kate"
    '';
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    tree
  ];
}
