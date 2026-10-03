# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [
  	
	# Essencials
	git
	curl
	wget
	htop
	tmux
        ghostty.terminfo    
      
  	# Dev
	neovim
   
  ];

  programs.bash = {
    shellAliases = {
      ll = "ls -l";
      gs = "git status";
      nrs = "sudo nixos-rebuild switch --flake .#pi";
      nc = "sudo nano /etc/nixos/configuration.nix";
    };
  };

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  boot.initrd.availableKernelModules = [ "xhci_pci" "pcie_brcmstb" "reset-raspberrypi" "usb_storage" "uas" "usbhid" ];
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  #   networking.networkmanager.enable = true;

  # -- Networking --

  networking.hostName = "pi"; 
  
  # Tailscale
  services.tailscale.enable = true; 
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
   
  # Start SSH
  services.openssh.enable = true;

  # Networking for home wifi
  networking.wireless = {
    enable = true;
    networks."Carbohydrate".pskRaw = "cb60e2b1a551ba8b19ba1c8851747beee73de0aa3c21c6f6f2e46f0157e16592";
  };
  hardware.enableRedistributableFirmware = true;

  # -- User --

  # Defines user for server
  users.users.kei = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKrF+siRa7198mKVcgE/5+Da7rChaDkj116DjnEiWAy/ kei@Trisium"];
  };
  security.sudo.wheelNeedsPassword = false;

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # -- Hardware Optimisation
 
  # Swap Memory
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 4096; # Size in megabytes (this creates a 4GB swap)
  } ];

  # Garbage collect every 7 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Hard-link identical files in the Nix store to save space
  nix.settings.auto-optimise-store = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

 # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
