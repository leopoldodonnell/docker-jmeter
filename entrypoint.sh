#!/bin/bash
set -e

JMETER_MODE=${JMETER_MODE:-master}
JMETER_LOG=${JMETER_LOG:-jmeter.log}

freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))

export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m -XX:NewSize=512m -XX:MaxNewSize=1024m"

if [[ "$JMETER_MODE" = "master" ]]; then
  JMETER_ARGS="-n -t ${JMETER_LOADTEST} ${JMETER_TESTARGS} -l ${JMETER_RESULTS} -r -p ${JMETER_PROPERTIES:-/jmeter.properties}"
elif [[ "$JMETER_MODE" = "worker" ]]; then
  JMETER_ARGS="-n -s"
  export JVM_ARGS="$JVM_ARGS \
            -Dserver.rmi.localport=50000 \
            -Dserver_port=1099 \
            -Djava.rmi.server.hostname=$(hostname -i)"
fi

echo "START Running Jmeter on `date` as $JMETER_MODE"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter.sh  -j $JMETER_LOG $JMETER_ARGS"

# Keep entrypoint simple: we must pass the standard JMeter arguments
jmeter.sh  -j $JMETER_LOG $JMETER_ARGS

# Tail the log file to keep the container running
tail -f $JMETER_LOG
