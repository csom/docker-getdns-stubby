FROM debian:buster
MAINTAINER "csoM <docker@mackapaer.se>"

RUN apt-get update && apt-get install -y libyaml-dev libssl-dev libtool-bin autoconf git make procps net-tools ldnsutils cmake check && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/getdnsapi/getdns.git

WORKDIR getdns

RUN git checkout master && git submodule update --init && libtoolize -ci && mkdir build
WORKDIR build
RUN cmake -DBUILD_STUBBY=ON -DENABLE_STUB_ONLY=ON -DCMAKE_INSTALL_PREFIX=/usr/local -DUSE_LIBIDN2=OFF DBUILD_LIBEV=OFF -DBUILD_LIBEVENT2=OFF -DBUILD_LIBUV=OFF .. && make && make install && ldconfig

COPY stubby.yml /usr/local/etc/stubby/stubby.yml

LABEL io.k8s.display-name="Stubby v0.3.0" \
      name="csoM/stubby" \
      maintainer="csoM"

WORKDIR /

RUN rm -rf /getdns

EXPOSE 8053

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD drill @127.0.0.1 -p 8053 cloudflare.com || exit 1

CMD [ "/usr/local/bin/stubby", "-C", "/usr/local/etc/stubby/stubby.yml" ]
