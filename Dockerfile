FROM docker.io/jeanblanchard/alpine-glibc

MAINTAINER dabing

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update

ENV FILEBEAT_VERSION=7.4.0

ADD ./filebeat.yml /usr/bin/

COPY filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz /tmp/filebeat.tar.gz

ADD ./start.sh /usr/

ADD jre8.tar.gz /usr/java/jdk

RUN cd /tmp \
  && tar xzvf filebeat.tar.gz \
  && cd filebeat-* \
  && cp filebeat /usr/bin \
  && mkdir -p /etc/filebeat \
  && rm -rf /tmp/filebeat* \
  && chown root.root /usr/bin/filebeat.yml \
  && chmod go-w /usr/bin/filebeat.yml \
  && chown -R root.root /usr/java \
  && chmod -R 755 /usr/java \
  && chown root.root /usr/start.sh \
  && chmod 755 /usr/start.sh 

ENV JAVA_HOME /usr/java/jdk

ENV PATH ${PATH}:${JAVA_HOME}/bin

CMD ["/usr/bin/filebeat","-e","-c","/usr/bin/filebeat.yml"]
