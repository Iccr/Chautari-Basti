from elixir:1.11.3

RUN mkdir -p /live/chautari

WORKDIR  /live/chautari
COPY wait-for-it.sh /usr/wait-for-it.sh
RUN chmod +x /usr/wait-for-it.sh

Run mix local.hex
Run mix archive.install hex phx_new 1.5.7
RUN  mix deps.get --only prod
Run MIX_ENV=prod mix compile
Run MIX_ENV=prod mix release
