{ config, pkgs, ... }:

{
  home.username = "minhchau";
  home.homeDirectory = "/home/minhchau";
  home.stateVersion = "26.05";
  programs.home-manager = {
    enable = true;
  };
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  }; 
  imports = [
    ./config/kitty.nix
    ./config/fish.nix 
    ./config/fastfetch.nix
  ];   
  xdg.configFile."niri/config.kdl" = {
    source = ./config/niri/config.kdl;
    force = true;
  };
  #xdg.configFile."fastfetch/config.jsonc" = {
  #  source = ./config/fastfetch/config.jsonc;
  #  force = true;
  #};
  #xdg.configFile."fish" = {
  #  source = ./config/fish;
  #  force = true;
  #  recursive = true;
  #};
  # xdg.configFile."kitty/kitty.conf" = {
  #  source = ./config/kitty/kitty.conf;
  #  force = true;
  #};
  xdg.configFile."mango/config.conf" = {
    source = ./config/mango/config.conf;
    force = true;
  };
    
  #home.packages = with pkgs; [
  #(librewolf.override {
  #  extraPrefsFiles = [(builtins.fetchurl {  
  #    url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
  #    sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
  #  })];
  #})
  #];
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;

    gtk.enable = true;
    #x11.enable = true;
  };
  home.pointerCursor.enable = true;
}
