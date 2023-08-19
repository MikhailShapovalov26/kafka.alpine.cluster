FROM alpine:latest
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    KAFKA_VERSION=3.5.1 \
    SCALA_VERSION=2.13\
    KAFKA_DIR_REPO=/opt/kafka \
    KAFKA_LOG=/kafkalogs
    # https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz

ENV KAFKA_DOWN_URL=https://downloads.apache.org/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz 

RUN set -eux;\
    apk update; \
    apk upgrade; \
    apk --no-cache add  --update wget bash curl git tar ca-certificates  openjdk17-jre tzdata; \
    curl -sSL "$KAFKA_DOWN_URL" | tar -xzf - -C /opt; \
    mv /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"  "$KAFKA_DIR_REPO"; \
    adduser -DH -s /sbin/nologin kafka; \
    chown -R kafka: /opt/kafka; \
    rm opt/kafka/config/server.properties; \
    mkdir -p "$KAFKA_LOG"

ENV PATH /sbin:/opt/kafka/bin/:$PATH

EXPOSE 9092
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh" ]
CMD ["kafka-server-start.sh", "opt/kafka/config/server.properties"]