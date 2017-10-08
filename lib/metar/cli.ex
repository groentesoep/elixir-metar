defmodule Metar.CLI do

  @moduledoc """
  Handle the command line parsing and dispatch to the various functions thath end up
  generating a string with the METAR of a given airport.
  """

  def main(argv) do
    argv
    |> parse_args()
    |> process
  end

  @doc """
  'argv' can be -h or --help, which returns :help.
  Otherwise it is a airport ICAO code.
  Returns a ':metar', or ':help' if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv,  switches: [ help: :boolean],
                                      aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _, _} ->
        :help
      { _, [ icao ], _} ->
        icao
      _ ->
        :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: metar <ICAO>

    ICAO is a four letter code for an airport.
    Example: EHAM (Amsterdam)
    """
    System.halt(0)
  end

  def process(icao) do
    Metar.XmlMetar.fetch(icao)
    |> decode_response
  end

  def decode_response({:ok, nil}), do: IO.puts "Invalid ICAO code given."
  def decode_response({:ok, body}), do: IO.puts "#{body}"
  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from NOAA: #{message}"
    System.halt(2)
  end

end