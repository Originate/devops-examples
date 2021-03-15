FROM node:14-buster-slim

VOLUME /app
WORKDIR /app

CMD ["sh", "-c", "yarn install && yarn watch"]
