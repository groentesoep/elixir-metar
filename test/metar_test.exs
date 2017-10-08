defmodule MetarTest do
  use ExUnit.Case
  doctest Metar

  import Metar.CLI, only: [ parse_args: 1 ]
  import Metar.XmlMetar, only: [ fetch: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",      "anything"]) == :help
    assert parse_args(["--help",  "anything"]) == :help
  end

  test "icao returned if ICAO given" do
    assert parse_args(["EHAM"]) == "EHAM"
  end

  test "fetch('EHAM') returns metar" do
    {:ok, body } = fetch("EHAM")
    assert Enum.take(body, 4) == 'EHAM'
  end

end
