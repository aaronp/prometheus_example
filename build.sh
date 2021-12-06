#!/usr/bin/env bash

function downloadAgent() {
  echo "getting jmx_prometheus_javaagent-0.16.1.jar"
  wget -O jmx_prometheus_javaagent-0.16.1.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.16.1/jmx_prometheus_javaagent-0.16.1.jar
}

function ensureAgent() {
  [[ -f jmx_prometheus_javaagent-0.16.1.jar ]] || downloadAgent
}

function fatJar() {
  [[ -f app.jar ]] || scala-cli package App.scala -o app.jar --assembly
}

function debug() {
  scala-cli App.scala
}

function run() {
  ensureAgent
  fatJar

  java -javaagent:./jmx_prometheus_javaagent-0.16.1.jar=8090:config.yaml \
   -Dcom.sun.management.jmxremote.ssl=false \
   -Dcom.sun.management.jmxremote.authenticate=false \
   -jar app.jar
}
