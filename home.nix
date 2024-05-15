{
  config,
  pkgs,
  ...
}: {
  imports = [./modules/zsh.nix];
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "dylan";
    homeDirectory = "/home/dylan";
    stateVersion = "23.11";

    packages = with pkgs; [
      neofetch
      btop
      docker
      zsh-autosuggestions
    ];
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ./~/nix/";
      config = "sudo nvim ~/nix/configuration.nix";
      home = "home-manager switch --flake ./~/nix/";
    };
  };
}
