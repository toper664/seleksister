import scala.io.Source
import java.io.FileNotFoundException

object InterpolationProgram {

  def interpolate(d: Int, x: Array[Double], y: Array[Double]): Array[Double] = {
    val p = Array.fill(d)(0.0)

    for (i <- 0 until d) {
      var product = 1.0
      val t = Array.fill(d)(0.0)

      for (j <- 0 until d) {
        if (i != j) {
          product *= (x(i) - x(j))
        }
      }

      product = y(i) / product
      t(0) = product

      for (j <- 0 until d) {
        if (i != j) {
          for (k <- d - 1 to 1 by -1) {
            t(k) += t(k - 1)
            t(k - 1) *= (-x(j))
          }
        }
      }

      for (j <- 0 until d) {
        p(j) += t(j)
      }
    }

    p
  }

  def main(args: Array[String]): Unit = {
    if (args.length < 1) {
      println("Error: Please provide a file path.")
      return
    }

    val path = args(0)
    try {
      val source = Source.fromFile(path)
      val lines = source.getLines().toList

      val (x, y) = lines.map { line =>
        val Array(a, b) = line.split(" ").map(_.toDouble)
        (a, b)
      }.unzip

      val p = interpolate(x.length, x.toArray, y.toArray)
      println(p.mkString(" "))

      source.close()
    } catch {
      case _: FileNotFoundException => println(s"Error: The file at '$path' doesn't exist!")
      case _: Exception => println("Error: Invalid input format")
    }
  }
}
