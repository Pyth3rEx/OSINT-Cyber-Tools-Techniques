{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "REPLACE-WITH-YOUR-NAME";
    userEmail = "REPLACE-WITH-YOUR-EMAIL";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nano";
    };
  };
}
