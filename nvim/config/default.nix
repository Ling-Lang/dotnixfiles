{
  # Import all your configuration modules here
  imports = [./bufferline.nix];

  colorschemes.onedark.enable = true;
  plugins = {
    airline.enable = true;
  };
}
