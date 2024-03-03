#!/usr/bin/env bash
docker rm workspace 2&> /dev/null
docker run -it \
  --name workspace \
  --mount type=bind,source="$(pwd)/lvim",target=/root/.config/lvim \
  workspace
