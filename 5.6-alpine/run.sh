#!/bin/sh

[ $DEBUG ] && set -e

SONARQUBE_JDBC_URL="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/sonar?\
useUnicode=true&\
characterEncoding=utf8&\
rewriteBatchedStatements=true&\
useConfigs=maxPerformance"

SONARQUBE_JDBC_USERNAME=${MYSQL_USER}
$SONARQUBE_JDBC_PASSWORD=${MYSQL_PASS}

# setting $SONARQUBE_WEB_JVM_OPTS
case ${MEMORY_SIZE:-small} in
    "micro")
       export SONARQUBE_WEB_JVM_OPTS="-Xms64m -Xmx64m"
       echo "Optimizing java process for 128M Memory...." >&2
       ;;
    "small")
       export SONARQUBE_WEB_JVM_OPTS="-Xms128m -Xmx128m"
       echo "Optimizing java process for 256M Memory...." >&2
       ;;
    "medium")
       export SONARQUBE_WEB_JVM_OPTS="-Xms256m -Xmx256m"
       echo "Optimizing java process for 512M Memory...." >&2
       ;;
    "large")
       export SONARQUBE_WEB_JVM_OPTS="-Xms512m -Xmx512m"
       echo "Optimizing java process for 1G Memory...." >&2
       ;;
    "2xlarge")
       export SONARQUBE_WEB_JVM_OPTS="-Xms1g -Xmx1g"
       echo "Optimizing java process for 2G Memory...." >&2
       ;;
    "4xlarge")
       export SONARQUBE_WEB_JVM_OPTS="-Xms2g -Xmx2g"
       echo "Optimizing java process for 4G Memory...." >&2
       ;;
    "8xlarge")
       export SONARQUBE_WEB_JVM_OPTS="-Xms4g -Xmx4g"
       echo "Optimizing java process for 8G Memory...." >&2
       ;;
    16xlarge|32xlarge|64xlarge)
       export SONARQUBE_WEB_JVM_OPTS="-Xms8g -Xmx8g"
       echo "Optimizing java process for biger Memory...." >&2
       ;;
    *)
       export SONARQUBE_WEB_JVM_OPTS="-Xms128m -Xmx128m"
       echo "Optimizing java process for 256M Memory...." >&2
       ;;
esac

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
