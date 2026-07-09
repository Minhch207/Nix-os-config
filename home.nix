{ config, pkgs, ... }:

{
  home.username = "minhchau";
  home.homeDirectory = "/home/minhchau";
  home.stateVersion = "26.05";
  programs.home-manager = {
    enable = true;
  };
  
  xdg.configFile."niri/config.kdl" = {
    source = ./config/niri/config.kdl;
    force = true;
  };
  xdg.configFile."fastfetch/config.jsonc" = {
    source = ./config/fastfetch/config.jsonc;
    force = true;
  };
  xdg.configFile."fish/config.fish" = {
    source = ./config/fish/config.fish;
    force = true;
  };
  xdg.configFile."kitty/kitty.conf" = {
    source = ./config/kitty/kitty.conf;
    force = true;
  };
  xdg.configFile."noctalia/settings.toml" = {
    source = ./config/noctalia/settings.toml;
    force = true;
  };
  

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = "catppuccin-mocha-dark-cursors";
    size = 24;

    gtk.enable = true;
    #x11.enable = true;
  };  
}
