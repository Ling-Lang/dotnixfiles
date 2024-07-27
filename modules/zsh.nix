{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # autosuggestion.enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "daveverwersc";
    };
    shellAliases = {
      rebuild = "sh ~/nix/rebuild.sh";
      flake = "sudo nix flake update ";
      config = "sudo nvim ~/nix/configuration.nix";
      home = "home-manager switch --flake ~/nix/";
      ls = "eza";
      q = "clear";
      tree = "eza -T";
    };
  };
}
