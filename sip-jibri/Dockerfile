# ------------------------------------------------------------------------------
# builder
# ------------------------------------------------------------------------------
FROM debian:bookworm-slim as builder

ARG PROJECT_REPO=https://github.com/jitsi/pjproject
ARG PROJECT_BRANCH=jibri-2.13-dev1

WORKDIR /src

RUN \
  export LC_ALL=C && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential git ca-certificates \
    libv4l-dev libsdl2-dev libavcodec-dev libavdevice-dev libavfilter-dev \
    libavformat-dev libavutil-dev libswscale-dev libasound2-dev libopus-dev \
    libvpx-dev && \
\
  git clone -b $PROJECT_BRANCH $PROJECT_REPO pjproject && \
  cd pjproject && ./configure && make dep && make && \
  cp pjsip-apps/bin/pjsua-x86_64-unknown-linux-gnu /src/pjsua

# ------------------------------------------------------------------------------
# sip-jibri
# ------------------------------------------------------------------------------
FROM debian:bookworm-slim

COPY --from=builder /src/pjsua /usr/local/bin/pjsua
COPY rootfs/ /

RUN \
  export LC_ALL=C && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --install-recommends \
    ffmpeg && \
  apt-get install -y --no-install-recommends \
    ca-certificates gnupg wget \
    dbus dbus-x11 fonts-noto jq libgl1-mesa-dri libv4l-0 rtkit unclutter \
    openjdk-17-jre-headless \
    chromium chromium-driver chromium-sandbox && \
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
  apt-get clean && \
  rm -rf /var/lib/apt/lists && \
  rm -rf /stage0

VOLUME /config