# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "minhchaupc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

   
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-unikey  
    ];
  };
      # swap 
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024; # 8 GiB
  }];
  zramSwap.enable = true;
  systemd.oomd.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."minhchau" = {
    isNormalUser = true;
    description = "Minh Chau";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tree ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   git
   papirus-icon-theme
   brightnessctl
   xdg-user-dirs
   systemd
   thunar
   tumbler
   kitty
   curl
   neovim
   btop
   niri
   wl-clipboard
   fish
   xwayland-satellite
   yazi
   xdg-desktop-portal-gtk
   wlsunset
   brave
   gearlever
   inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
   keepassxc
   (catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    loginBackground = true;
  })
   fastfetch
   nwg-look
   p7zip
   uv
   xarchiver
   cacert
   nightfox-gtk-theme
   bibata-cursors
   github-cli
  ]; 
  fonts.packages = with pkgs; [
   nerd-fonts.jetbrains-mono
  ];
  programs.nix-ld.enable = true;
  programs.localsend.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  programs.bash = {
  interactiveShellInit = ''
      # "check if parent process is not fish" && "make nested shells work properly"
      if grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
          # set $SHELL for better integration with programs like nix shell, tmux, etc.
          SHELL=${pkgs.fish}/bin/fish exec fish
      fi
    '';
  };
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;  
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.udisks2.enable = true;
  hardware.graphics = {
	enable = true;
	extraPackages = with pkgs; [
		intel-media-driver
		intel-compute-runtime
		vpl-gpu-rt
	];
  };
  xdg.portal = {
	enable = true;
	extraPortals = with pkgs; [
		xdg-desktop-portal-gtk
	];
	config.common.default = "*";
  };
  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
    thunar-volman
  ];
  services.tumbler.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;
  services.fstrim.enable = true;
  services.libinput.enable = true;
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    user = "minhchau";
    dataDir = "/home/minhchau";
    configDir = "/home/minhchau/.config/syncthing";
  };
  services.xserver.enable = true;
  services.displayManager.sddm = {
   enable = true;
   theme = "catppuccin-mocha-mauve";
   setupScript = ''
    ${pkgs.xrdb}/bin/xrdb -merge - <<EOF
    Xcursor.theme: Bibata-Modern-Classic
    Xcursor.size: 24
    EOF
   '';
  };

  networking.firewall.allowedTCPPorts = [ 8384 ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  # List services that you want to enable:
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "26.05"; 

}
