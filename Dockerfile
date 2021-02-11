FROM rust:1.45 AS librespot

RUN apt-get update \
 && apt-get -y install build-essential portaudio19-dev curl unzip \
 && apt-get clean && rm -fR /var/lib/apt/lists

ARG ARCH=amd64
ARG LIBRESPOT_VERSION=0.1.3

COPY ./install-librespot.sh /tmp/
RUN /tmp/install-librespot.sh

FROM debian:buster

ARG SNAPCAST_VERSION=0.23.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl libasound2 mpv \
 && curl -L -o /tmp/snapserver.deb "https://github.com/badaix/snapcast/releases/download/v0.23.0/snapserver_0.23.0-1_amd64.deb" \
 && dpkg -i /tmp/snapserver.deb || apt-get install -f -y --no-install-recommends \
 && apt-get clean && rm -fR /var/lib/apt/lists

COPY --from=librespot /usr/local/cargo/bin/librespot /usr/local/bin/

COPY run.sh /
CMD ["/run.sh"]

ENV DEVICE_NAME=Snapcast
EXPOSE 1704/tcp 1705/tcp
