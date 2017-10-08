defmodule Metar.XmlMetar do
  require Logger
  import SweetXml

  @user_agent [ {"User-agent", "Elixir Bastiaan"}]

  def fetch(icao) do
    Logger.info "Fetching #{icao}'s metar."
    metar_url(icao)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def metar_url(icao) do
    "https://aviationweather.gov/adds/dataserver_current/httpparam?dataSource=metars&requestType=retrieve&format=xml&stationString=#{icao}&hoursBeforeNow=1"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Succesful response."
    { :ok, parse_xml(body) }
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    Logger.info "Error #{status} returned."
    { :error, parse_xml(body) }
  end

  def parse_xml(body) do
    body |> xpath(~x"//data/METAR/raw_text/text()")
  end
end