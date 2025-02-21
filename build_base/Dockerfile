FROM docker:dind

WORKDIR /app

COPY log.sh /app/log.sh
RUN chmod +x /app/log.sh

VOLUME /logs
VOLUME /repo

RUN apk add --no-cache git
RUN git clone https://github.com/dygeraldino/Test-Codes /repo

ENTRYPOINT ["/app/log.sh"]