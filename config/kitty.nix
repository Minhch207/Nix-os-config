{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMonoNL Nerd Font";
      size = 12;
    };
    extraConfig = "
      cursor_shape beam
      draw_minimal_borders yes
      mouse_map left click ungrabbed mouse_handle_click selection link prompt
      open_url_with librewolf
      detect_urls yes
      copy_on_select yes
      background_opacity 0.85
      ";
  };
}
