
FROM elixir:1.9.0-alpine

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force
RUN mix local.rebar
RUN mix deps.get
# Compile the project
RUN mix do compile
# Run Seeds
# RUN mix run apps/core/priv/repo/seeds.exs

