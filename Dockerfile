FROM alpine:3.7

RUN apk update
RUN set -ex && \
        apk add --no-cache \
        git \
        perl \
        curl

RUN git clone https://github.com/schacon/cowsay.git /tmp/cowsay
WORKDIR /tmp/cowsay
RUN ./install.sh /usr/local
ADD cows/* /usr/local/share/cows/

RUN rm -rf /var/cache/apk/* \
        /var/tmp/* \
        /tmp/*

RUN apk del git curl

ENTRYPOINT ["/usr/local/bin/cowsay"]