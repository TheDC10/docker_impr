FROM docker:dind

WORKDIR /app

RUN apk add --no-cache git bash
RUN git clone https://github.com/dygeraldino/Test-Codes /repo

COPY log.sh /app/log.sh
COPY docker-compose.yml /app/docker-compose.yml

RUN chmod +x /app/log.sh
VOLUME /logs

ENTRYPOINT ["/app/log.sh"]