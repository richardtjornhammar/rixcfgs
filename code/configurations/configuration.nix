# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  #
  # Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  #
  # Use the GRUB 2 boot loader.
  # For GRUB the disk boot partition needs to start at 1 or 32
  #boot.loader.grub.enable = true;
  #boot.loader.grub.version = 2;
  #boot.loader.grub.efiSupport = true;
  #
  # Use the systemd boot loader
  boot.loader.systemd-boot.enable = true;
  #
  # Boot options needed irregardless of boot type
  # layout:  sda has type: gpt (BIOS start,EFI-system,Linux LVM)
  #
  #boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "rixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n = {
    defaultLocale = "sv_SE.UTF-8";
    inputMethod = {
      #
      # ibus is standard with plasma 
      #enabled = "ibus";
      #ibus.engines = with pkgs.ibus-engines; [ libpinyin table table-chinese ];
      #
      # fcitx is better for gaming in X configure the IM and add in chinese pinyin
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ rime cloudpinyin ];
    };
    supportedLocales 	= [ "sv_SE.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  console = {
    keyMap = "sv-latin1";
    font   = "Lat2-Terminus16";
    colors = [	"002b36" "dc322f" "859900" "b58900"
		"268bd2" "d33682" "2aa198" "eee8d5" 
		"002b36" "cb4b16" "586e75" "657b83" 
		"839496" "6c71c4" "93a1a1" "fdf6e3" ];
    earlySetup = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";
  #
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  nixpkgs.config = {
  #  allowUnfreePredicate = (pkg: with builtins; elem ( parseDrvName pkg.name ) [ "nvidia" "vscode" ]);
    allowUnfree = true;
  #  packageOverrides = pkgs: {
  #    openssl = pkgs.libressl.override {
  #      # curl need openssl or recursion loop
  #      fetchurl = pkgs.fetchurlBoot;
  #    };
  #  };
  };
  #
   
  # ORACLE VIRTUALBOX STUFF
  virtualisation.virtualbox.host.enable = true ;
  users.extraGroups.vboxusers.members = [ "rictjo" ] ;
  virtualisation.virtualbox.host.enableExtensionPack = true ;
  
  environment.systemPackages = with pkgs; [
     wget vim htop iotop busybox 
     clang gcc gfortran git screen 
     python ghc R python39 kotlin
     firefox opera libreoffice kate
     geckodriver weechat tor keybase
     (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ]; nativeOnly = true; }).run
  ];

  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "se";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.xserverArgs = ["-logfile" "/var/log/X.log"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rictjo = {
     isNormalUser = true;
     extraGroups = [ "wheel" "vboxusers" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}


