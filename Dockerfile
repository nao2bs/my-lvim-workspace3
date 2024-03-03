# syntax=docker/dockerfile:1
FROM ruby:3.2-alpine3.18 AS base
# FROM alpine:edge AS base
WORKDIR /root
SHELL ["/bin/sh", "-c"]

RUN apk add git man-pages neovim alpine-sdk zsh curl --update

# install deps needed by neovim
RUN apk add wget gzip neovim-doc ripgrep nodejs npm --update

# pre-download lazy.nvim
RUN git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable /root/.local/share/nvim/lazy/lazy.nvim

# install neovim
#RUN curl -OL https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
#RUN tar zxf nvim-linux64.tar.gz
#RUN mv ./nvim-linux64/bin/nvim /usr/local/bin/
#RUN cp -r ./nvim-linux64/share/* /usr/share/

# install lunarvim dependencies
RUN apk add yarn python3 cargo bash --update

# install ruby
RUN apk add make gcc sqlite-dev 
# install tree-sitter-cli with cargo because `npm i tree-sitter-cli` fails on
# apple silicon. Install other rust dependencies while at it.
RUN npm install tree-sitter-cli 
# RUN cargo install fd-find ripgrep

RUN gem install rails

COPY .zshrc .zshrc
COPY projects projects

#RUN source .zshrc
# install lunarvim
RUN su -c "bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies"

# copy these hidden folders during development for faster
# loading of lazy.nvim, mason, and treesitter
#COPY .cache /root/.cache
#COPY .local /root/.local

FROM base
SHELL ["/bin/zsh", "-c"]
WORKDIR /root/projects/pets
COPY lvim /root/.config/lvim
CMD ["/bin/zsh"]
