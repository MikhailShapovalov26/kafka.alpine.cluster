#!/bin/bash
set -e
echo
HOSTNAME=$(hostname)
if [[ ! -f "$KAFKA_DIR_REPO/config/server.properties" ]]; then
    CONFIG="$KAFKA_DIR_REPO/config/server.properties"
    {
        echo "${BROKER_ID:-0}"
        echo "listeners=PLAINTEXT://$HOSTNAME:9092" 
        echo "advertised.listeners=PLAINTEXT://:9092" 
        echo "num.network.threads=${NUM_NETWORK:-10}" 
        echo "num.io.threads=${NUM_IO_THREADS:-8}" 
        echo "socket.send.buffer.bytes=${SOCKET_SEND_BUFFER:-102400}" 
        echo "socket.receive.buffer.bytes=${SOCKET_RECEIVE_BYFFER:-102400}" 
        echo "socket.request.max.bytes=${SOCKET_REQUEST_MAX_B:-104857600}" 
        echo "log.dirs=$KAFKA_LOG" 
        echo "delete.topic.enable=${DELETE_TOPIC:-true}" 
        echo "num.partitions=${NUM_PARTITIONS:-1}" 
        echo "num.recovery.threads.per.data.dir=${NUM_RECOVERY_THREADS_PER:-1}" 
        echo "offsets.topic.replication.factor=${REPLIC_FACOTR:-1}" 
        echo "transaction.state.log.replication.factor=${TRANSACTION_STATE_LOG_REPLIC_FAC:-1}" 
        echo "transaction.state.log.min.isr=${TRANSACTION_STATE_LOG_MIN_ISR:-1}" 
        echo "log.retention.hours=${LOG_RETENT_HOURS:-168}" 
        echo "log.retention.check.interval.ms=${LOG_RETENT_CHECK_INTERVAL_MS:-300000}" 
        echo "zookeeper.connection.timeout.ms=18000" 
        echo "auto.create.topics.enable=${AUTO_CREATE_TOPIC:-true}" 
        echo "group.initial.rebalance.delay.ms=0" 
    } >> "$CONFIG"
    for server in $ZOO_SERVER_CONNECT; do
        echo "zookeeper.connect=$server" >> "$CONFIG"
    done
    chown -R kafka: "$CONFIG"
fi
exec "$@"