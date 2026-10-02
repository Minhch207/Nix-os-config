# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.noctalia-greeter.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "minhchaupc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;


  networking.nameservers = [
    "1.1.1.1"
    "45.90.30.0"
    "9.9.9.9"
    "149.112.112.112"
  ];
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
    size = 16*1024; # 16 GiB
  }];
  zramSwap.enable = true;
  systemd.oomd.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."minhchau" = {
    isNormalUser = true;
    description = "Minh Chau";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd"];
    packages = with pkgs; [ tree ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   git
   brightnessctl
   xdg-user-dirs
   systemd
   curl
   neovim
   btop
   niri   
   wl-clipboard
   xwayland-satellite
   xdg-desktop-portal-gtk
   wlsunset
   inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
   keepassxc
   p7zip
   uv
   xarchiver
   bibata-cursors
   github-cli
   gcc
   python3
   scrcpy
   android-tools
   zed-editor
   bubblewrap
   wget
   nautilus
   (catppuccin-gtk.override {
      accents = [ "pink" "blue" "green" "rosewater" "lavender" "sapphire" "sky" ]; # You can specify multiple accents here to output multiple themes
      size = "standard" ;
      tweaks = [ "rimless" "black" "normal" ]; # You can also specify multiple tweaks here
      variant = "mocha";
    })
    (catppuccin-papirus-folders.override {
      accent = "blue";
      flavor = "mocha";
    })
    mango
    librewolf
    gnome-disk-utility
    cosmic-viewer
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
  programs.mango = {
    enable = true;
  };
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;  
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.ollama = {
  enable = true;
  package = pkgs.ollama-vulkan;
  environmentVariables = {
    OLLAMA_MAX_LOADED_MODELS = "1";
    OLLAMA_CONTEXT_LENGTH = "32768";
    OLLAMA_IGPU_ENABLE = "1";
    OLLAMA_KV_CACHE_TYPE = "q8_0";
    OLLAMA_FLASH_ATTENTION = "1";
  };
  # Optional: preload models, see https://ollama.com/library
    #loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b"];
};
  hardware.graphics = {
	enable = true;
	extraPackages = with pkgs; [
		intel-media-driver
		intel-compute-runtime
		vpl-gpu-rt
    intel-gpu-tools
	];
  };
  xdg.portal = {
	enable = true;
	extraPortals = with pkgs; [
		xdg-desktop-portal-gtk
	];
	config.common.default = "*";
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };
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
  services.displayManager.noctalia-greeter = {
    enable = true;
    greeter-args = "";
    settings = {
        cursor = {
          theme = "Bibata-Modern-Classic";
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard.layout = "us";
    };
  };
  networking.firewall.allowedTCPPorts = [ 8384 ];
  
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [
      virtiofsd
    ];
  };
  programs.virt-manager.enable = true;
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
  # List services that you want to enable:
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "dayly";
    options = "--delete-older-than 3d";
  };
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  system.stateVersion = "26.05"; 

}
