{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  #
  ################################# SWAPFILE
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 64*1024;
  } ];
  #
  ################################# HARDWARE CALIBRATION
  #
  # Enable OpenGL
  hardware.graphics.enable      = true;
  hardware.graphics.enable32Bit = true;
  hardware.sane.enable          = true; # HW PERIPHERAL SCANNERS
  hardware.xone.enable          = true; # support for the xbox controller USB dongle 
  hardware.nvidia = {
    #
    # Modesetting is needed for most wayland compositors.
    modesetting.enable          = true;
    powerManagement.enable      = false; # Not a laptop
    powerManagement.finegrained = false; # Not supported here
    open                        = false;
    nvidiaSettings              = true;
    #
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  #
  # Disable sound with pipewire. Se below settings must be checked vs pipewire
  hardware.pulseaudio.enable       = true;
  hardware.pulseaudio.support32Bit = true;  
  security.rtkit.enable = true;
  #
  ########################################### BOOT CONF / BOOTLOADER
  boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.efi.efiSysMountPoint = "/boot/efi";
      #
      ######################### BEGIN PIMP MY BOOT
      #plymouth = {
      #  enable = true;
      #  theme = "glitch";
      #  themePackages = with pkgs; [
      #    # By default we would install all themes
      #    (adi1090x-plymouth-themes.override {
      #      selected_themes = [ "glitch" ];
      #    })
      #  ];
      #};
      ## Enable "Silent Boot"
      #consoleLogLevel = 0;
      #initrd.verbose = false;
      #kernelParams = [
      #  "quiet"
      #  "splash"
      #  "boot.shell_on_fail"
      #  "loglevel=3"
      #  "rd.systemd.show_status=false"
      #  "rd.udev.log_level=3"
      #  "udev.log_priority=3"
      #];
      ## Hide the OS choice for bootloaders.
      ## It's still possible to open the bootloader list by pressing any key
      ## It will just not appear on screen unless a key is pressed
      #loader.timeout = 3;
      ########################### END PIMP MY BOOT
      #
      # boot GC
      loader.systemd-boot.configurationLimit=42;
      #
      # Setup keyfile
      initrd.secrets = {
        "/crypto_keyfile.bin" = null;
      };
      #
      # SPECIFIC KERNEL VERSION (LATEST 2025/01/09) NVIDIA SUPPORT BROKEN AFTER 6.12
      kernelPackages = pkgs.linuxPackages_6_12;
  };
  #
  ########################################### NETWORKING
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  #
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  #
  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ 8888 ];
  #networking.firewall.allowedUDPPorts = [ 8888 ];
  #
  #
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  #
  ########################################### SYSTEM LOCALISATION
  #
  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "sv_SE.UTF-8";

  # LC_ALL SHOULD NOT BE SET IN EXTRA SETTINGS
  i18n.extraLocaleSettings = {
    LANGUAGE            = "sv_SE.UTF-8";
    LC_ADDRESS		= "sv_SE.UTF-8";
    LC_IDENTIFICATION	= "sv_SE.UTF-8";
    LC_MEASUREMENT	= "sv_SE.UTF-8";
    LC_MONETARY		= "sv_SE.UTF-8";
    LC_NAME		= "sv_SE.UTF-8";
    LC_NUMERIC		= "sv_SE.UTF-8";
    LC_PAPER		= "sv_SE.UTF-8";
    LC_TELEPHONE	= "sv_SE.UTF-8";
    LC_TIME		= "sv_SE.UTF-8";
    LANG                = "sv_SE.UTF-8";
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" "sv_SE.UTF-8/UTF-8" ];
  i18n.inputMethod = {
     enable = true;
     type = "ibus";
     ibus.engines = with pkgs.ibus-engines; [ libpinyin rime uniemoji table ];
   };
   #
   ########################################## ASIAN FONTS AND LOW LEVEL KEYMAP  
   fonts.packages = with pkgs; [
     dejavu_fonts
     noto-fonts noto-fonts-extra
     babelstone-han
     noto-fonts-cjk-sans
     noto-fonts-cjk-serif
     ubuntu_font_family
     liberation_ttf
   ];

   #fc-list : family | grep 'Mono CJK'
   fonts.fontconfig.defaultFonts = {
     monospace = [
      "DejaVu Sans Mono"
      "Noto Sans Mono CJK SC"
      "Noto Sans Mono CJK TC"
     ];
     #fc-list : family | grep 'Sans CJK'
     sansSerif = [
      "DejaVu Sans"
      "Noto Sans CJK SC"
      "Noto Sans CJK TC"
     ];
     # fc-list : family | grep 'Serif CJK'
     serif = [
      "DejaVu Serif"
      "Noto Serif CJK SC"
      "Noto Serif CJK TC"
     ];
   };
  #
  # Configure keymap in X11 in services
  # Configure console keymap
  console.keyMap = "sv-latin1";
  #
  ################################################ PROGRAM CONFS
  programs.slock.enable       = true;
  programs.java.enable        = true;
  programs.gamemode.enable    = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;      # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; 
  };
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };  
  ################################################ NIXPKGS CONF
  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-x11" "nvidia-settings" "nvidia-persistenced"
    "steam" "steam-original" "steam-run" "steam-unwrapped" "zoom"
    "discord" "lutris" "vmd" "xow_dongle-firmware"
  ];
  #
  ################################################ SYS ENVIRONMENT
  environment.systemPackages = with pkgs; [
    wget discord mono libgdiplus nano gst 
    gcc zlib cmake xdg-user-dirs gfortran
    tree git distrobox fish mlocate vim
    libblockdev alsa-utils xdg-utils
    #
    ocl-icd opencl-headers
    pciutils usbutils
    linuxPackages.nvidia_x11
    vulkan-tools glxinfo
    #
    kerbrute krb5 cntlm wireshark
    fastfetch
    #
    wineWowPackages.stable
    winetricks
    #
    iotop ghc python3 R kotlin curl
    clojure leiningen
  ];
  environment.pathsToLink = [ "/share/man" "/share/doc" "/bin" "/libexec" ];
  environment.extraOutputsToInstall = [ "man" "doc" ];
  #
  ############################################### USER ENVS
  users.users.richardt = {
    isNormalUser = true;
    description = "Richard Tjörnhammar";
    extraGroups = [ "networkmanager" "wheel" "lp" "scanner" "sound" "video" "gamemode" ];
    packages = with pkgs; [
      firefox lutris 
      xterm
      steam discord
      thunderbird glxinfo
      protonup protonplus protonup-qt
      appimage-run
      audacious bottles
      gimp chromium
      isoimagewriter
      qbittorrent quassel remmina
      vlc zoom-us
      zapzap
    ];
  };
  #
  ############################################### SERVICES
  #
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Potentially insecure setting but required for distrobox env to forward X
  #services.openssh.settings.X11Forwarding = true;
  #
  # Enable CUPS to print documents. YOU ARE NOT MY PRINTER
  services.printing.enable = false;
  #
  # The pipewire service. LEGACY IS PULSE INSTEAD OF PIPEWIRE
  services.pipewire = {
    enable            = false;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };
  #
  services.xserver = {
    enable  = true;
    autorun = true;
    enableCtrlAltBackspace = true;
    exportConfiguration    = true;
    #
    windowManager.i3 = {
        enable = true;
	# package = pkgs.i3-gaps; # i3 fork with gaps between tiled windows
        extraPackages = with pkgs; [
          dmenu i3status i3lock i3blocks xorg.xrandr xfce.xfce4-screenshooter
       ];
      };
    desktopManager.lxqt.enable = true;
    #desktopManager.xterm.enable = false;
    #
    xkb.layout    = "se";
    videoDrivers  = [ "nvidia" ];
    displayManager.xserverArgs = ["-logfile" "/var/log/X.log"];
  };
  services.displayManager.defaultSession = "none+i3";
  #
  # TESTING PLASMA # WORKS BUT DOESNT SOLVE ANYTHING
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  #
  services.locate = {
    enable    = true;
    package   = pkgs.mlocate;
    localuser = null;
  };
  #
  ############################################## NIX SETTINGS
  # Flakes and home-manager
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ############################################## VIRTUALISATION AND CONTAINER TECH SUPOPRT
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # FLATPAK
  xdg.portal = {
    enable = true;
    #
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde
    ];
    xdgOpenUsePortal = true;
  };
  # USE LEXOGRAPHICALLY FIRST PORTAL 
  xdg.portal.config.common.default = "*";
  services.flatpak.enable = true;
  #
  ############################################# GUFF
  #
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #
  system.stateVersion = "23.05"; # Did you read the comment?
}
