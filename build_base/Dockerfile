FROM docker:dind

WORKDIR /repo

RUN apk add --no-cache git

RUN git clone https://github.com/dygeraldino/Test-Codes /repo

COPY docker-compose.yml /repo

CMD ["docker-compose", "up", "--build"]

