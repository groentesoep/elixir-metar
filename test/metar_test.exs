defmodule MetarTest do
  use ExUnit.Case
  doctest Metar

  import Metar.CLI, only: [ parse_args: 1, validate_length: 1 ]
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

  test "validate_length('EHAM') returns icao" do
    assert validate_length("EHAM") == "EHAM"
  end

  test "validate_length('EHA') returns :wrong" do
    assert validate_length("EHA") == :wrong
  end

end
