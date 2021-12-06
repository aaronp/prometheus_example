FROM virtuslab/scala-cli:latest AS build
RUN mkdir /app
COPY ["jmx_prometheus_javaagent-0.16.1.jar", "App.scala", "build.sh", "run.sh", "config.yaml", "/app/"]
WORKDIR /app
RUN source ./build.sh && fatJar

FROM openjdk:8u312-jre-slim
#FROM adoptopenjdk/openjdk16:x86_64-alpine-jre-16.0.1_9
#FROM adoptopenjdk/openjdk16:jre-11.0.9.1_1-alpine@sha256:b6ab039066382d39cfc843914ef1fc624aa60e2a16ede433509ccadd6d995b1f
RUN mkdir /app
#RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
COPY --from=build /app/* /app
WORKDIR /app
#RUN chown -R javauser:javauser /app
#USER javauser
#CMD "java" "-jar" "java-application.jar"
EXPOSE 8080
EXPOSE 8090
# CMD ["cat", "/app/build.sh", "|", "sh", "&&", "run"]
# CMD "sh -C 'cat /app/build.sh | sh && run'"
CMD run.sh