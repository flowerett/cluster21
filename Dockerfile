FROM flowerett/alpine-elixir:1.6.6

ENV PORT 4000
ENV MIX_ENV prod

WORKDIR /opt/app
COPY . .
