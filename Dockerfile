FROM node:16.20 as base
LABEL Author FullDive backend team

FROM base as build

ENV PROTOC_ZIP=protoc-3.13.0-linux-x86_64.zip
RUN apt-get update && apt-get install -y unzip && apt-get install -y curl && apt-get install -y openssl
RUN curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.13.0/$PROTOC_ZIP \
    && unzip -o $PROTOC_ZIP -d /usr/local bin/protoc \
    && unzip -o $PROTOC_ZIP -d /usr/local 'include/*' \
    && rm -f $PROTOC_ZIP \

ENV NODE_DIR /home/node/app
WORKDIR $NODE_DIR
# TODO add protobuf
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn compile-all
RUN yarn build


# Intermediate cleaning image makes the release lighter. While yarn cleans dev
# dependencies, it creates intermediate files during installation. With cleaned
# image, we avoid these intermediate files. Essentialy, it prepares node_modules
# for copying.
#FROM build AS cleaned
#RUN yarn install --production

# Relase image. With this image we no more need NPM_TOKEN arg in, that prevents
# from the secret leak.
#FROM base AS release
#
#ENV NODE_DIR /home/node/app
#WORKDIR $NODE_DIR
#
#COPY --from=build $NODE_DIR/package.json  ./
##COPY --from=cleaned $NODE_DIR/node_modules  ./node_modules
#COPY --from=build $NODE_DIR/config        ./config
#COPY --from=build $NODE_DIR/schemas       ./schemas
#COPY --from=build $NODE_DIR/dist          ./dist
#RUN yarn install --production

EXPOSE 8080

USER node:node
CMD ["yarn", "start:prod"]
