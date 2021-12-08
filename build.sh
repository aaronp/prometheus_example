#!/usr/bin/env bash

#
# Good, old-school bash script used to build stuff :-)
#
# You can use this build file locally, provided you have https://scala-cli.virtuslab.org/
#
# ... to just compile/run locally (and browse to localhost:8080 to test the REST app)
# source build.sh && debug
#
# ... to build a fat-jar and run:
# source build.sh && run
#
#
function downloadAgent() {
  echo "getting jmx_prometheus_javaagent-0.16.1.jar"
  wget -O jmx_prometheus_javaagent-0.16.1.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.16.1/jmx_prometheus_javaagent-0.16.1.jar
}

# Makes sure we have the jmx agent jar downloaded
function ensureAgent() {
  [[ -f jmx_prometheus_javaagent-0.16.1.jar ]] || downloadAgent
}

# just for convenience in local development:
# source ./build.sh && clean
function clean() {
  rm *.jar
  rm -rf prometheus_data
  rm -rf target
  rm -rf grafana
}

# used by Dockerfile to create the app.jar fat jar
function fatJar() {
  [[ -f app.jar ]] || scala-cli package App.scala -o app.jar --assembly
}

# just for convenience/documentation in how to go about local development:
# source ./build.sh && debug
function debug() {
  scala-cli App.scala
}

# just for convenience in running the instrumented fat-jar locally
# source ./build.sh && run
# then browse to localhost:8080/ and localhost:8090/metrics
function run() {
  ensureAgent
  fatJar

  java -javaagent:./jmx_prometheus_javaagent-0.16.1.jar=8090:config.yaml \
   -Dcom.sun.management.jmxremote.ssl=false \
   -Dcom.sun.management.jmxremote.authenticate=false \
   -jar app.jar
}
