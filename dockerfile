from elixir:1.11.3

RUN mkdir -p /live/chautari

WORKDIR  /live/chautari
COPY . .
COPY wait-for-it.sh /usr/wait-for-it.sh
RUN chmod +x /usr/wait-for-it.sh



RUN mix local.hex --force && \
    mix local.rebar --force
ENV MIX_ENV=prod
Run mix archive.install hex phx_new 1.5.7
RUN  mix deps.get --only prod
Run MIX_ENV=prod mix compile
Run MIX_ENV=prod mix release

# CMD ["_build/prod/rel/finder/bin/finder", "start"]