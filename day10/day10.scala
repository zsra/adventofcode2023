import scala.io.Source

object Main extends App {
  val pipeTypes: Map[Char, List[String]] = Map(
    '|' -> List("n", "s"),
    '-' -> List("w", "e"),
    'L' -> List("n", "e"),
    'J' -> List("n", "w"),
    '7' -> List("s", "w"),
    'F' -> List("s", "e"),
    'S' -> List("n", "s", "w", "e")
  )

  val directions: Map[String, (Int, Int, String)] = Map(
    "n" -> (-1, 0, "s"),
    "s" -> (1, 0, "n"),
    "w" -> (0, -1, "e"),
    "e" -> (0, 1, "w")
  )

  val filename = "day10.in"
  val lines = Source.fromFile(filename).getLines().toList

  val map: Array[Array[Char]] = lines.map(_.trim.toCharArray).toArray

  val start: (Int, Int) = map.zipWithIndex.collect {
    case (line, i) if line.contains('S') => (i, line.indexOf('S'))
  }.head

  var encounteredPlaces: Map[(Int, Int), Int] = Map()

  var searchQueue: List[((Int, Int), Int)] = List((start, 0))

  while (searchQueue.nonEmpty) {
    val (current, distance) = searchQueue.head
    searchQueue = searchQueue.tail

    if (encounteredPlaces.contains(current)) {
      // Already visited
    } else {
      encounteredPlaces += (current -> distance)
      val (i, j) = current
      val availableDirections = pipeTypes(map(i)(j))

      for (direction <- availableDirections) {
        val (di, dj, opposite) = directions(direction)
        val newCoord = (i + di, j + dj)

        if (newCoord._1 < 0 || newCoord._1 >= map.length || newCoord._2 < 0 || newCoord._2 >= map(newCoord._1).length) {
          // Out of bounds
        } else {
          val target = map(newCoord._1)(newCoord._2)

          if (pipeTypes.contains(target)) {
            val targetDirections = pipeTypes(target)

            if (targetDirections.contains(opposite)) {
              searchQueue = searchQueue :+ (newCoord, distance + 1)
            }
          }
        }
      }
    }
  }

  val maxDistance: Int = encounteredPlaces.values.max
  println(maxDistance)

  def getPieceType(i: Int, j: Int): Option[Char] = {
    val reachableDirections = directions.keys.filter { direction =>
      val (di, dj, opposite) = directions(direction)
      val newCoord = (i + di, j + dj)

      newCoord._1 >= 0 && newCoord._1 < map.length &&
        newCoord._2 >= 0 && newCoord._2 < map(newCoord._1).length &&
        encounteredPlaces.contains(newCoord) &&
        pipeTypes.contains(map(newCoord._1)(newCoord._2)) &&
        pipeTypes(map(newCoord._1)(newCoord._2)).contains(opposite)
    }

    pipeTypes.find { case (_, pieceDirections) =>
      reachableDirections.size == pieceDirections.size && reachableDirections.forall(pieceDirections.contains)
    }.map(_._1)
  }

  map(start._1)(start._2) = getPieceType(start._1, start._2).getOrElse(' ')

  for (i <- map.indices) {
    var norths = 0
    for (j <- map(i).indices) {
      val place = map(i)(j)

      if (encounteredPlaces.contains((i, j))) {
        val pipeDirections = pipeTypes(place)
        if (pipeDirections.contains("n")) {
          norths += 1
        }
      } else {
        if (norths % 2 == 0) {
          map(i)(j) = 'O'
        } else {
          map(i)(j) = 'I'
        }
      }
    }
  }

  val insideCount = map.map(_.mkString).mkString("\n").count(_ == 'I')
  println(insideCount)
}
