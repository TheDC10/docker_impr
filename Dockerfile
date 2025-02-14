FROM docker:dind

RUN apk add --no-cache git bash

COPY build-img.sh /build-img.sh
RUN chmod +x /build-img.sh

ENTRYPOINT ["/build-img.sh"]