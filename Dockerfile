FROM postgres:13

# POSTGIS
LABEL maintainer="PostGIS Project - https://postgis.net"

ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION 3.1.4+dfsg-1.pgdg110+1

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
      && rm -rf /var/lib/apt/lists/*

# PLV8
ENV PLV8_VERSION=2.3.15 \
    PLV8_SHASUM="1a96c559d98ad757e7494bf7301f0e6b0dd2eec6066ad76ed36cc13fec4f2390"

RUN buildDependencies="build-essential \
    ca-certificates \
    curl \
    git-core \
    python \
    python3 \
    gpp \
    cpp \
    pkg-config \
    apt-transport-https \
    cmake \
    libc++-dev \
    libc++abi-dev \
    libtinfo5 \
    postgresql-server-dev-$PG_MAJOR" \
    runtimeDependencies="libc++1" \
  && apt-get update \
  && apt-get install -y --no-install-recommends ${buildDependencies} ${runtimeDependencies} \
  && mkdir -p /tmp/build \
  && curl -o /tmp/build/v$PLV8_VERSION.tar.gz -SL "https://github.com/plv8/plv8/archive/v${PLV8_VERSION}.tar.gz" \
  && cd /tmp/build \
#   && echo $PLV8_SHASUM v$PLV8_VERSION.tar.gz | sha256sum -c \
  && tar -xzf /tmp/build/v$PLV8_VERSION.tar.gz -C /tmp/build/ \
  && cd /tmp/build/plv8-$PLV8_VERSION \
  && make static \
  && make install \
  && strip /usr/lib/postgresql/${PG_MAJOR}/lib/plv8-${PLV8_VERSION}.so \
  && rm -rf /root/.vpython_cipd_cache /root/.vpython-root \
  && apt-get clean \
  && apt-get remove -y ${buildDependencies} \
  && apt-get autoremove -y \
  && rm -rf /tmp/build /var/lib/apt/lists/*