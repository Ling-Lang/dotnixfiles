{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./system/hardware-configuration.nix
    ./system/disk-config.nix
  ];
  # general Stuff #
  hardware.bluetooth.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  nixpkgs.config.allowUnfree = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiInstallAsRemovable = true;
  networking.hostName = "nixos"; # Define your hostname.
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})];
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  programs.zsh.enable = true;
  time.timeZone = "Europe/Berlin";
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["dylan"];
  # Display environment #
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # services.xserver.libinput.enable = true;
  # user config
  users.users.dylan = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      firefox
      neofetch
      eza
      vscode-fhs
      alacritty
      discord
      psst
      htop
      prusa-slicer
    ];
    shell = pkgs.zsh;
  };

  #system packages
  environment.systemPackages = with pkgs; [
    vim
    home-manager
    alejandra
    git
    libnotify
    zsh
    neovim
    wget
  ];

  environment.shells = [
    pkgs.zsh
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
