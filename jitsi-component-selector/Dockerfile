# ------------------------------------------------------------------------------
# builder
# ------------------------------------------------------------------------------
FROM node:20 as builder

ARG PROJECT_REPO="https://github.com/jitsi/jitsi-component-selector.git"
ARG PROJECT_BRANCH="main"
ARG PROJECT_CHECKOUT="main"

WORKDIR /app

RUN \
  git clone -b ${PROJECT_BRANCH} ${PROJECT_REPO} repo && \
  cd repo && git checkout ${PROJECT_CHECKOUT} && \
  npm install && npm run build

# ------------------------------------------------------------------------------
# prod
# ------------------------------------------------------------------------------
FROM node:20

WORKDIR /app

COPY --from=builder /app/repo/bundle/app.js /app/app.js

USER node

CMD ["nodejs", "/app/app.js"]
