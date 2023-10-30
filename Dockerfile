FROM ubuntu:22.04

RUN apt-get update --fix-missing && apt-get install createrepo-c dpkg-dev apt-utils gnupg2 gzip rpm curl -y && rm -rf /var/lib/apt/lists/*

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN bash -i -c "nvm install 8"
RUN bash -i -c "npm install --global yarn"

WORKDIR /opt/service

# Copy PJ, changes should invalidate entire image
COPY package.json yarn.lock /opt/service/

# Copy commong typings
COPY typings /opt/service/typings

# Copy TS configs
COPY tsconfig* /opt/service/

# Build backend
COPY src /opt/service/src

# Build Frontend

COPY public /opt/service/public
COPY webpack.*.js postcss.config.js README.md /opt/service/

# Install dependencies
RUN bash -i -c "yarn --cache-folder ../ycache && yarn build:server && yarn build:fe:prod && yarn --production --cache-folder ../ycache && rm -rf ../ycache"

EXPOSE 8080

# символьная ссылка на утилиту createrepo_c
RUN ln -s /usr/bin/createrepo_c /usr/bin/createrepo

# включаем отладку Nucleus
ENV DEBUG *

CMD ["bash", "-i", "-c", "npm run start:server:prod --"]
