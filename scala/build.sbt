lazy val scala = project
  .in(file("."))
  .settings(
    scalaVersion := "3.3.1",

    libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.17" % Test
  )
