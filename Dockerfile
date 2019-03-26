FROM alpine:3.9

ARG cowsay_version="0.0.5"

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
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN rm -rf /var/cache/apk/* \
        /var/tmp/* \
        /tmp/*

RUN apk del git curl

RUN echo ${cowsay_version} > /etc/cowsay_version
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
