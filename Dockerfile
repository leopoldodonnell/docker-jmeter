FROM openjdk:8u121-jdk-alpine

# Install cURL and CA Certificates for SSL support in the JVM, using glibc to interface oracle JRE with libc to run virtual machines
RUN apk --update add curl ca-certificates tar unzip && \
    curl -Ls https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.21-r2/glibc-2.21-r2.apk> /tmp/glibc-2.21-r2.apk && \
    apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
    mkdir -p /aws && \
	  apk -Uuv add groff less python py-pip && \
	  pip install awscli && \
	  apk --purge -v del py-pip && \
	  rm /var/cache/apk/*    


ARG JMETER_VERSION="3.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN	${JMETER_HOME}/bin
ENV JMETER_DOWNLOAD_URL  http://mirror.serversupportforum.de/apache/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_VERSION=1.4.0
ENV JMETER_PLUGINS_DOWNLOAD_URL_1  https://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-${JMETER_PLUGINS_VERSION}.zip
ENV JMETER_PLUGINS_DOWNLOAD_URL_2  https://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-${JMETER_PLUGINS_VERSION}.zip
ENV JMETER_PLUGINS_DOWNLOAD_URL_3  https://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-${JMETER_PLUGINS_VERSION}.zip


RUN mkdir -p /tmp/dependencies /tmp/dependencies/jmeter-plugins /opt && \
  curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz && \
  curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL_1} > /tmp/dependencies/jmeter-plugins/JMeterPlugins-Standard-${JMETER_PLUGINS_VERSION}.zip && \
  curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL_2} > /tmp/dependencies/jmeter-plugins/JMeterPlugins-Extras-${JMETER_PLUGINS_VERSION}.zip && \
  curl -L --silent ${JMETER_PLUGINS_DOWNLOAD_URL_3} > /tmp/dependencies/jmeter-plugins/JMeterPlugins-ExtrasLibs-${JMETER_PLUGINS_VERSION}.zip && \
  tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
  unzip -o /tmp/dependencies/jmeter-plugins/JMeterPlugins-Standard-${JMETER_PLUGINS_VERSION}.zip -d  /opt/apache-jmeter-${JMETER_VERSION}/ && \
  unzip -o /tmp/dependencies/jmeter-plugins/JMeterPlugins-Extras-${JMETER_PLUGINS_VERSION}.zip -d  /opt/apache-jmeter-${JMETER_VERSION}/ && \
  unzip -o /tmp/dependencies/jmeter-plugins/JMeterPlugins-ExtrasLibs-${JMETER_PLUGINS_VERSION}.zip -d  /opt/apache-jmeter-${JMETER_VERSION}/ && \
  rm -rf /tmp/dependencies

ENV PATH $PATH:$JMETER_BIN

COPY entrypoint.sh ${JMETER_HOME}/

WORKDIR	${JMETER_HOME}

# By default run JMeter as a master
ENV JMETER_MODE master

# Send in the name of the JMeter file as a Command argument
ENTRYPOINT ["${JMETER_HOME}/entrypoint.sh"]
