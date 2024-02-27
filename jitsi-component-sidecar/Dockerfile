# ------------------------------------------------------------------------------
# builder
# ------------------------------------------------------------------------------
FROM debian:bookworm-slim as builder

ARG PROJECT_REPO="https://github.com/jitsi/jitsi-component-sidecar.git"
ARG PROJECT_BRANCH="main"
ARG PROJECT_CHECKOUT="main"
ARG DEBFULLNAME="Jitsi Team"
ARG DEBEMAIL="dev@jitsi.org"

COPY rootfs/ /
WORKDIR /src

RUN \
  export LC_ALL=C && \
  export DEBIAN_FRONTEND=noninteractive && \
  mv /etc/apt/sources.list.d/nodesource.list /tmp/nodesource.list  && \
\
  apt-get update && \
  apt-get install -y wget gnupg && \
  wget -T 30 -qO /tmp/nodesource.gpg.key \
    https://deb.nodesource.com/gpgkey/nodesource.gpg.key && \
  cat /tmp/nodesource.gpg.key | \
    gpg --dearmor >/usr/share/keyrings/nodesource.gpg && \
  mv /tmp/nodesource.list /etc/apt/sources.list.d/nodesource.list && \
\
  apt-get update && \
  apt-get install -y --no-install-recommends git jq && \
  apt-get install -y --no-install-recommends build-essential && \
  apt-get install -y --no-install-recommends devscripts debhelper && \
  apt-get install -y --no-install-recommends nodejs && \
\
  git clone -b ${PROJECT_BRANCH} ${PROJECT_REPO} repo && \
  cd repo && git checkout ${PROJECT_CHECKOUT} && \
  export DEBFULLNAME=$DEBFULLNAME && \
  export DEBEMAIL=$DEBEMAIL && \
  cd resources && bash build_deb_package.sh

# ------------------------------------------------------------------------------
# prod
# ------------------------------------------------------------------------------
#FROM node:20

#COPY --from=builder /app/build /usr/share/nginx/html
#RUN sleep 3
