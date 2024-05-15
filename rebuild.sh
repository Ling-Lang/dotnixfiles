#!/usr/bin/env bash
#
# I believe there are a few ways to do this:
#
#    1. My current way, using a minimal /etc/nixos/configuration.nix that just imports my config from my home directory (see it in the gist)
#    2. Symlinking to your own configuration.nix in your home directory (I think I tried and abandoned this and links made relative paths weird)
#    3. My new favourite way: as @clot27 says, you can provide nixos-rebuild with a path to the config, allowing it to be entirely inside your dotfies, with zero bootstrapping of files required.
#       `nixos-rebuild switch -I nixos-config=path/to/configuration.nix`
#    4. If you uses a flake as your primary config, you can specify a path to `configuration.nix` in it and then `nixos-rebuild switch —flake` path/to/directory
# As I hope was clear from the video, I am new to nixos, and there may be other, better, options, in which case I'd love to know them! (I'll update the gist if so)

# A rebuild script that commits on a successful build
set -e

# Default flake path
flake_path="./"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --full)
            full_rebuild=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

#cd into nix dir
pushd ~/nix

# Edit your config
$EDITOR configuration.nix

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."
# sudo nixos-rebuild switch --flake ~/nix/
# Rebuild, output simplified errors, log trackebacks
if [ "$full_rebuild" = true ]; then
    echo "Performing full rebuild..."
    home-manager switch --flake "$flake_path" 2>&1 | tee home-manager.log
    sudo nixos-rebuild switch --flake "$flake_path" 2>&1 | tee nixos-switch.log
    grep --color error nixos-switch.log && exit 1
    grep --color error home-manager.log && exit 1
else
    echo "Performing shallow build"
    sudo nixos-rebuild switch --flake "$flake_path" 2>&1 | tee nixos-switch.log
    grep --color error home-manager.log && exit 1
fi

# Get current generation metadata
current=$(nixos-rebuild --flake "$flake_path" list-generations | grep current)

# Commit all changes with the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
