// using scala 3.1.0
// using lib com.lihaoyi::cask:0.8.0
// using lib io.dropwizard.metrics:metrics-core:4.1.2
// using lib io.dropwizard.metrics:metrics-jmx:4.1.2

import com.codahale.metrics.MetricRegistry
import com.codahale.metrics.jmx.JmxReporter

/**
 * See https://metrics.dropwizard.io/4.1.2/getting-started.html
 */
object App extends cask.MainRoutes {
  private val metrics = new MetricRegistry()

  @cask.get("/")
  def usage() = """
  Usage:
  
  GET /meter/:name # increment meter 'name'
  GET /inc/:name   # increment counter 'name'
  GET /dec/:name   # decrement counter 'name'
  GET /histogram/:name/:value   # set histogram 'name' to value :value
  """

  def name(str : String) = s"app.lication.${str}"

  @cask.get("/meter/:metricName")
  def mark(metricName: String) : String = {
    val m = metrics.meter(name(metricName))
    val result = m.mark()
    s"""mean rate: ${m.getMeanRate}
       |1 min rate: ${m.getOneMinuteRate}
       |""".stripMargin
  }

  @cask.get("/inc/:metricName")
  def inc(metricName: String) : String = {
    val counter = metrics.counter(name(metricName))
    val result = counter.inc()
    s"inc: $metricName -> ${counter.getCount}"
  }

  @cask.get("/dec/:metricName")
  def dec(metricName: String) : String = {
    val counter = metrics.counter(name(metricName))
    val result = counter.dec()
    s"dec: $metricName -> ${counter.getCount}"
  }


  @cask.get("/histogram/:metricName/:amount")
  def histogram(metricName: String, amount : Int) : String = {
    val counter = metrics.histogram(name(metricName))
    val result = counter.update(amount)
    val snap = counter.getSnapshot
    val baos = new java.io.ByteArrayOutputStream()
    snap.dump(baos)

    s"histogram: $metricName -> ${new String(baos.toByteArray)}"
  }

  private def box(str : String): String = {
    val lines = str.linesIterator.toList
    val maxLen = (0 +: lines.map(_.length)).max
    val boxed = lines.map { line =>
      s" | ${line.padTo(maxLen, ' ')} |"
    }
    val bar = " +-" + ("-" * maxLen) + "-+"
    (bar +: boxed :+ bar).mkString("\n")
  }

  override def host: String = "0.0.0.0"

  initialize()
  JmxReporter.forRegistry(metrics).build().start()

  println(box(
    s""" 🚀 browse to localhost:8080 and/or open jconsole 🚀
      |      host : $host
      |      port : $port
      |   verbose : $verbose
      | debugMode : $debugMode
      |""".stripMargin))
}