FROM registry.access.redhat.com/ubi8/ubi:8.6
WORKDIR /work/
COPY . .

RUN yum -y install gcc \
    && yum -y install gcc glibc-devel zlib-devel \
    && yum -y install wget \
    && wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.3.0/graalvm-ce-java17-linux-amd64-22.3.0.tar.gz \
    && gunzip graalvm-ce-java17-linux-amd64-22.3.0.tar.gz \
    && tar xvf graalvm-ce-java17-linux-amd64-22.3.0.tar \
    && rm -f graalvm-ce-java17-linux-amd64-22.3.0.tar \
    && export PATH=/work/graalvm-ce-java17-22.3.0/bin:$PATH \
    && export JAVA_HOME=/work/graalvm-ce-java17-22.3.0 \
    && gu install native-image \
    && ./mvnw clean \
    && ./mvnw package -Pnative \
    && mv target/pfp-service-runner application

#RUN chown 1001 /work \
#    && chmod "g+rwX" /work \
#    && chown 1001:root /work

#COPY /work/target/code-with-quarkus-1.0.0-SNAPSHOT-runner /work/application

EXPOSE $PORT

CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]
