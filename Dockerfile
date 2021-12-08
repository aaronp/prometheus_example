FROM virtuslab/scala-cli:latest AS build
RUN mkdir /app
COPY ["App.scala", "build.sh", "run.sh", "config.yaml", "/app/"]
WORKDIR /app
RUN source ./build.sh && ensureAgent && fatJar

FROM openjdk:18-oraclelinux8
RUN mkdir /app
COPY --from=build /app/* /app
WORKDIR /app
EXPOSE 8080
EXPOSE 8090
CMD /app/run.sh