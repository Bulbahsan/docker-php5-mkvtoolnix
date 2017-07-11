FROM alpine:3.6
MAINTAINER Sergey Savchenko <skymlife@yandex.ru>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk add --update curl wget zip mc htop sqlite supervisor mkvtoolnix \
    ca-certificates openssl tzdata && update-ca-certificates && \
    cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    mkdir -p /var/log/php /var/www/site && touch /var/log/php/php-errors.log

RUN apk add php5 php5-mysql php5-mysqli php5-pdo \
    php5-pdo_mysql php5-json php5-xml php5-zip php5-zlib php5-sqlite3 php5-openssl \
    php5-pdo_sqlite php5-iconv php5-curl && rm -rf /var/cache/apk/* && \
    ln -s /usr/bin/php5 /usr/bin/php

COPY ./php.ini /etc/php5/conf.d/php.ini
COPY ./index.php /var/www/site/index.php
COPY ./supervisord.conf /etc/supervisord.conf
COPY ./start.sh /start.sh

VOLUME ["/var/www/site"]

WORKDIR /var/www/site
EXPOSE 4711

CMD ["/start.sh"]
CMD ["/usr/bin/supervisord"]