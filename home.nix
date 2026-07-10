{ config, pkgs, ... }:

{
  home.username = "minhchau";
  home.homeDirectory = "/home/minhchau";
  home.stateVersion = "26.05";
  programs.home-manager = {
    enable = true;
  };
  xdg.enable = true; 
  xdg.configFile."niri" = {
    source = ./config/niri;
    force = true;
    recursive = true;
  };
  xdg.configFile."fastfetch/config.jsonc" = {
    source = ./config/fastfetch/config.jsonc;
    force = true;
  };
  xdg.configFile."fish" = {
    source = ./config/fish;
    force = true;
    recursive = true;
  };
  xdg.configFile."kitty/kitty.conf" = {
    source = ./config/kitty/kitty.conf;
    force = true;
  };
  xdg.configFile."noctalia" = {
    source = ./config/noctalia;
    force = true;
    recursive = true;
  };
  services.udiskie = {
    enable = true;
    settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
            # replace with your favorite file manager
            file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        };
    };
  };  

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;

    gtk.enable = true;
    #x11.enable = true;
  };
  home.pointerCursor.enable = true;
}
