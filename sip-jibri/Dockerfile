# ------------------------------------------------------------------------------
# builder
# ------------------------------------------------------------------------------
FROM debian:trixie-slim as builder

ARG PJPROJECT_ARCHIVE=https://github.com/jitsi-contrib/pjproject/archive/refs/tags
ARG PJPROJECT_VERSION=v20240818

WORKDIR /src

RUN \
  export LC_ALL=C && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential git ca-certificates \
    libv4l-dev libsdl2-dev libavcodec-dev libavdevice-dev libavfilter-dev \
    libavformat-dev libavutil-dev libswscale-dev libasound2-dev libopus-dev \
    libvpx-dev libssl-dev && \
\
  wget -q $PJPROJECT_ARCHIVE/$PJPROJECT_VERSION.tar.gz && \
  tar zxf $PJPROJECT_VERSION.tar.gz && \
  cd pjproject-$(echo $PJPROJECT_VERSION | tr -d 'v') && \
  ./configure && make dep && make && \
  cp pjsip-apps/bin/pjsua-x86_64-unknown-linux-gnu /src/pjsua

# ------------------------------------------------------------------------------
# sip-jibri
# ------------------------------------------------------------------------------
FROM debian:trixie-slim

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

COPY --from=builder /src/pjsua /usr/local/bin/pjsua
COPY rootfs/ /

RUN \
  dpkgArch="$(dpkg --print-architecture)" && \
  case "${dpkgArch##*-}" in \
    "amd64") TPL_ARCH=amd64; S6_ARCH=amd64 ;; \
    "arm64") TPL_ARCH=arm64; S6_ARCH=aarch64 ;; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac && \
  export LC_ALL=C && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    apt-utils ca-certificates gnupg wget \
    dbus dbus-x11 fonts-noto jq libgl1-mesa-dri libv4l-0 rtkit unclutter \
    openjdk-17-jre-headless \
    chromium chromium-driver chromium-sandbox && \
  apt-get install -y --install-recommends \
    ffmpeg && \
  apt-get -y purge upower && \
\
  cp /stage0/extras/jitsi-stable.list /etc/apt/sources.list.d/ && \
  wget -T 30 -qO /tmp/gpg.key https://download.jitsi.org/jitsi-key.gpg.key && \
  cat /tmp/gpg.key | gpg --dearmor >/usr/share/keyrings/jitsi.gpg && \
  apt-get update && \
  apt-get install -y --install-recommends jibri && \
  adduser jibri rtkit && \
\
  cp /stage0/overwrites/pjsua.config /etc/jitsi/jibri/pjsua.config && \
  cp /stage0/overwrites/pjsua.sh /opt/jitsi/jibri/pjsua.sh && \
  cp /stage0/overwrites/finalize_sip.sh /opt/jitsi/jibri/finalize_sip.sh && \
  cp /stage0/overwrites/asoundrc /home/jibri/.asoundrc && \
  cp -arp /stage0/extras/icewm/* /home/jibri/.icewm/ && \
  chmod 755 /usr/local/bin/pjsua && \
  chmod 755 /home/jibri/.icewm/startup && \
\
  wget -qO /usr/bin/tpl https://github.com/jitsi/tpl/releases/download/v1.1.1/tpl-linux-${TPL_ARCH} && \
  chmod 755 /usr/bin/tpl && \
  mkdir /tmp/s6 && \
  wget -qO /tmp/s6/s6-overlay-${S6_ARCH}.tar.gz \
    https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz && \
  cd /tmp/s6/ && tar zxf s6-overlay-${S6_ARCH}.tar.gz && \
  mv bin/* /bin/ && rm -rf bin usr/bin/execlineb s6-overlay-*.tar.gz && \
  cp -arp /tmp/s6/* / && \ 
\
  apt-get clean && \
  rm -rf /var/lib/apt/lists && \
  rm -rf /stage0 && \
  rm -rf /tmp/s6

VOLUME /config

ENTRYPOINT [ "/init" ]
