FROM alpine

ENV SLEEP_TIME=60

RUN apk add --no-cache curl coreutils bash \
    && curl -L -o /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && curl -L -o /bin/url-encode https://gist.githubusercontent.com/thecampagnards/adbe033f3beed12a3b93217a3a661bda/raw/url-encode.sh \
    && chmod u+x /bin/jq \
    && chmod u+x /bin/url-encode \
    && jq -h

WORKDIR /opt/docker-registry-listener

COPY entrypoint.sh .
RUN chmod u+x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]