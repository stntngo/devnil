FROM nixos/nix

RUN nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
RUN nix-channel --update
RUN nix-env --set-flag priority 0 man-db-2.10.2

RUN nix-shell '<home-manager>' -A install

COPY home.nix /root/.config/home-manager/home.nix
COPY nvim /root/dotfiles/nvim

ENV LANG C.UTF-8

RUN home-manager switch

# Kind of a dumb thing going on here, but I want to make sure that
# the fennel config files have been compiled to lua during the
# container build process.
RUN nvim --headless -c 'quitall'

WORKDIR /root/code
ENTRYPOINT ["zsh"]
