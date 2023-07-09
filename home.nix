{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "root";
  home.homeDirectory = "/root";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    curl
    diffutils
    ripgrep
    fd

    neovim-nightly

    go
    gopls

    zig
    zls

    rustup

    ocaml
    opam
    dune_3
    ocamlPackages.ocaml-lsp

    clojure
    clojure-lsp

    nodejs_20
    python311

    zsh
    glibc
  ];

  home.file = {
    ".config/nvim/init.lua".source = /root/dotfiles/nvim/init.lua;
    ".config/nvim/fnl".source = /root/dotfiles/nvim/fnl;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/root/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      "edit-home" = "nvim /root/.config/home-manager/home.nix";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "pyenv" ];
      theme = "robbyrussell";
    };
  };
       

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      aniseed
      nightfox-nvim
      undotree
      mini-nvim
      bufferline-nvim
      popup-nvim
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      
      nvim-treesitter
      nvim-treesitter-parsers.c
      nvim-treesitter-parsers.go
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.ocaml
      nvim-treesitter-parsers.python
      nvim-treesitter-parsers.fennel
      nvim-treesitter-parsers.zig
      nvim-treesitter-parsers.clojure
      nvim-treesitter-parsers.nix

      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      cmp-treesitter

      todo-comments-nvim
      trouble-nvim
      vim-fugitive
      lualine-nvim
    ];
  };
}
