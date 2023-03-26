(defproject trivia "0.1.0-SNAPSHOT"
  :description "Clojure ugly trivia"
  :dependencies [[org.clojure/clojure "1.8.0"]]
  :main ^:skip-aot trivia.Gamerunner
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
