# /dev/nil

`/dev/nil` is an attempt at creating as reproducible a development experience for myself as possible.

- `Dockerfile` defines a `nixos/nix` derived container image that doesn't doo much beyond installing `home-manager` and copying over the configuration files.
- `home.nix` defines the nix environment that will be managed in the container. This includes all system packages and even all vim/neovim packages.
- Everything else is configuration that gets sym-linked into the appropriate locations.
