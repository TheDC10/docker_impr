FROM docker:dind

WORKDIR /repo

VOLUME /logs

RUN apk add --no-cache git

RUN git clone https://github.com/dygeraldino/Test-Codes /repo

COPY docker-compose.yml /repo

COPY log.sh /log.sh

RUN chmod +x /log.sh

ENTRYPOINT ["/log.sh"]