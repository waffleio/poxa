FROM alpine:3.4

# Install erlang
RUN set -x \
  && apk --no-cache --update add \
    erlang \
    erlang-asn1 \
    erlang-crypto \
    erlang-dev\
    erlang-erl-interface \
    erlang-eunit \
    erlang-inets \
    erlang-parsetools \
    erlang-public-key \
    erlang-sasl \
    erlang-ssl \
    erlang-syntax-tools \
  && rm -rf /var/cache/apk/*

# Install elixir
ENV ELIXIR_VERSION 1.3.3

RUN set -x \
  && apk --no-cache --update add --virtual build-dependencies ca-certificates git openssl \
  && wget https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip \
  && mkdir -p /opt/elixir-${ELIXIR_VERSION}/ \
  && unzip Precompiled.zip -d /opt/elixir-${ELIXIR_VERSION}/ \
  && rm Precompiled.zip \
  && rm -rf /var/cache/apk/*

ENV PATH $PATH:/opt/elixir-${ELIXIR_VERSION}/bin

ENV MIX_ENV prod
ENV PORT 3008
EXPOSE $PORT

COPY . /src

WORKDIR /src/

RUN set -x \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix do deps.get, compile, compile.protocols

CMD ["mix", "run", "--no-halt"]
