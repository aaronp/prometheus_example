# Prometheus/Grafana Example

This project was created to demonstrate:
 * Using dropwizard counters, meters and histograms
 * Exposing those metric MBeans via an HTTP endpoint using jmx_prometheus and config.yaml
 * Putting it all together with Prometheus and Grafana in a docker-compose

The end result of running `docker-compose up` will be that:

#### You can easily create/update counters, meters and histograms via GET requests in your browser

 * [localhost:8080/inc/foo](http://localhost:8080/inc/foo) will increment the 'foo' counter (for any string 'foo')
 * [localhost:8080/dec/foo](http://localhost:8080/dec/bar) will decrement the 'bar' counter (for any string 'bar')
 * [localhost:8080/meter/fizz](http://localhost:8080/meter/fizz) will mark the 'fizz' meter (for any string 'fizz')
 * [localhost:8080/histogram/buzz/123](http://localhost:8080/histogram/buzz/123) will set the value 123 of the 'buzz' histogram (for any string 'buzz')
 * [localhost:8080](http://localhost:8080) will show some basic usage text

#### You see the JMX metrix
Either use `jconsole` to browse the app_lication MBeans.
The names of which are matched in the `config.yaml` in order to expose nice key/value pairs.

Browse to [localhost:8090/metres](http://localhost:8090/metres) to see the exposed key/value pairs


# Browser Usage

# Development
Use [scala-cli](https://scala-cli.virtuslab.org/docs) for all the things (TM)

This basic app uses [cask](https://com-lihaoyi.github.io/cask/) and [dropwizard](https://metrics.dropwizard.io/4.1.2/getting-started.html)
to allow users to easily mess with metrics, exported using [Prometheus JMX Exporter](https://github.com/prometheus/jmx_exporter)

## Running
```
scala-cli App.scala
```

And use GET verbs (naughty) in your browser to e.g.
 * increment 'foo' (just any name will do):  [http://localhost:8080/inc/foo](http://localhost:8080/inc/foo)
 * decrement 'bar' (just any name will do):  [http://localhost:8080/dec/bar](http://localhost:8080/dec/bar)
 * set value 123 on histogram 'whatevs':  [http://localhost:8080/histogram/whatevs/123](http://localhost:8080/histogram/whatevs/123)
 * set mark on meter 'dave':  [http://localhost:8080/meter/dave](http://localhost:8080/meter/dave)

## Testing
You can check the metrics by opening MBeans in `jconsole` 

## Building

 1) Create a fat jar 'app.jar':
```
scala-cli package App.scala -o app.jar --assembly
```
 2) get prometheus

# exposes e.g. metrics_app_lication_example_50thPercentile{type="histograms",} 212.0
browse to http://localhost:8090/metrics

# Prometheus

## A Note on config.yaml and Regex Patterns

The 'pattern'

```
docker run -v $(pwd)/prometheus/:/etc/prometheus/ \
  --net host \
  -v $(pwd)/prometheus_data:/prometheus prom/prometheus:v2.1.0 \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.console.libraries=/usr/share/prometheus/console_libraries \
  --web.console.templates=/usr/share/prometheus/consoles
  
```
# Notes

See https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/vegasbrianc/prometheus/master/pwd-stack.yml
