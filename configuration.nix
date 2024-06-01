# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# { config, lib, pkgs, unstable, pkgs-unstable, ... }:
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.kernelModules = ["amdgpu"];
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 4;
    };
  };

  virtualisation.libvirtd.enable = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    # settings.auto-optimise-store = true;
    # gc = {
    #   automatic = true;
    #   dates = "daily";
    #   options = "--delete-older-than +10";
    # };
  };

  nixpkgs.config.allowUnfree = true;

  # Required by Obsidian
  nixpkgs.config.permittedInsecurePackages = [
                "electron-25.9.0"
              ];

  networking.hostName = "ncs";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages_5.rocm-runtime
    rocmPackages_5.rocminfo
    amdvlk
    rocmPackages_5.clr.icd
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  systemd.tmpfiles.rules = [
     "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  ];

  # Enable sound with Pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };  
    xserver = {
      enable = true;
    };
    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    locate = {
      enable = true;
      package = pkgs.mlocate;
    };
    dbus.enable = true;
    upower.enable = true;
    udisks2.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ari = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "power" "adbusers" "kvm" "qemu-libvirtd" "libvirtd" ]; # "wheel" -> Enable ‘sudo’ for the user.
    initialPassword = "password";
    packages = with pkgs; [
      chromium
      # tree
      kitty
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    #neovim
    wget
    waybar
    dunst
    terminus_font
    brillo
    fontpreview
    fzf
    ripgrep
    git
    ranger
    lsd
    pavucontrol
    polkit_gnome
    tldr
    ydotool
    # gnumake
    upower
    obsidian
    bluez
    prismlauncher
    podman
    spotify
    brightnessctl
    wayshot
    slurp
    cliphist
    wl-clipboard
    pfetch
    udisks
    udiskie
    telegram-desktop
    glow
    python3
    playerctl
    d-spy
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtmultimedia
    nix-prefetch-git
    pulseaudio
    rofi-wayland-unwrapped
    fuzzel
    wtype
    vcv-rack
    bridge-utils
    qemu
    ncmpcpp
    openjdk11
    # davinci-resolve
    clinfo
    # rocmPackages_5.rocminfo
    # rocmPackages_5.rocm-runtime
  ];

    fonts.packages = with pkgs; [
      fira-code-nerdfont
      nerdfonts
      font-awesome
      google-fonts
    ];
    fonts.fontDir.enable = true;

  ### STABLE+UNSTABLE
  # environment.systemPackages = 
    # (with pkgs-unstable; [
    #   hyprland
    # ])
    #
    # ++
    # (with pkgs; [
    #   neovim
    #   wget
    #   waybar
    #   dunst
    #   terminus_font
    #   brillo
    #   fontpreview
    #   fzf
    #   ripgrep
    #   git
    #   ranger
    #   lsd
    #   pavucontrol
    #   polkit_gnome
    #   tldr
    #   ydotool
    #   #gnumake
    #   upower
    #   obsidian
    #   bluez
    #   prismlauncher
    #   podman
    #   spotify
    #   brightnessctl
    #   wayshot
    #   slurp
    #   cliphist
    #   wl-clipboard
    #   pfetch
    #   udisks
    #   udiskie
    #   telegram-desktop
    #   python3
    #   playerctl
    #   dfeet
    #   libsForQt5.qt5.qtgraphicaleffects
    #   libsForQt5.qt5.qtmultimedia
    #   nix-prefetch-git
    #   pulseaudio
    #   rofi
    #   fuzzel
    #   wtype
    #   vcv-rack
    #   bridge-utils
    #   qemu
    #   tree
    #   glow
    #   ncmpcpp
    # ]);

 
#  environment.systemPackages = [
#    (waybar.overrideAttrs (oldAttrs: {
#        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
#      })
#    )
#  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # SUB-OPTIMAL SCREEN INTERACTION -> USE HYPRLAND XDG PORTAL
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  programs = {
    steam.enable = true;
    adb.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    zsh.enable = true;
    neovim = {
      defaultEditor = true;
      enable = true;
      withPython3 = true;
      #extraPackages = with pkgs; [
        #fd
        #gh # for github integration
        #ripgrep
        
        ## needed to compile fzf-native for telescope-fzf-native.nvim
        #gcc
        #gnumake
        
        ## language servers
        #nil # Nix LSP
        #lua-language-server
        
        #nixpkgs-fmt # I have nil configured to call this for formatting
      #];
    };
    virt-manager.enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
