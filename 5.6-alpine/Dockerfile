FROM java:8-alpine

MAINTAINER David Gageot <david.gageot@sonarsource.com>

ENV SONAR_VERSION=5.6 \
    SONARQUBE_HOME=/opt/sonarqube

# timezone and libc
RUN apk add --no-cache tzdata libc6-compat && \
       ln -s /lib /lib64 && \
       cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
       echo "Asia/Shanghai" >  /etc/timezone && \
       date && apk del --no-cache tzdata

# add sonar user
RUN sed -i -r 's/nofiles/sonar/' /etc/group && \
    adduser -u 200 -D -S -G sonar sonar

# Http port
EXPOSE 9000

RUN set -x \
    && apk add --no-cache gnupg unzip curl wget bash su-exec \
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \

    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \

    && mkdir /opt \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

VOLUME ["/opt/sonarqube/data", "/opt/sonarqube/extensions"]

WORKDIR /opt/sonarqube
COPY run.sh /opt/sonarqube/bin/
ENTRYPOINT ["./bin/run.sh"]
