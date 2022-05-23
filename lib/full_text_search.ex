defmodule SecEdgar.FullTextSearch do
  alias SecEdgar.Clients.FullTextSearch, as: FullTextSearchClient

  # iex -S mix
  # Finch.start_link(name: SecEdgar.Clients.FullTextSearch)
  # list = SecEdgar.FullTextSearch.list_for_ticker("BRK")
  # entity = SecEdgar.FullTextSearch.find_for_ticker("BRK")
  def perform(search_term) do
    FullTextSearchClient.perform(search_term) |> parse_as_json
  end

  # ex:
  # [
  #   %{
  #     "_id" => "1067983",
  #     "_index" => "edgar_entity_20220521_040325",
  #     "_score" => 831.6911,
  #     "_source" => %{
  #       "entity" => "BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)",
  #       "entity_words" => "BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)",
  #       "rank" => 62987021,
  #       "tickers" => "BRK-B, BRK-A"
  #     },
  #     "_type" => "_doc"
  #   },
  #   ...
  # ]
  def only_those_with_tickers({:ok, response}) do
    response["hits"]["hits"] |> Enum.filter(&(!is_nil(&1["_source"]["tickers"])))
  end

  def list_for_ticker(ticker) do
    ticker
    |> perform()
    |> only_those_with_tickers()
    |> Enum.map(&formatted_entity(&1["_source"], &1["_id"]))
  end

  def find_for_ticker(ticker) do
    ticker
    |> list_for_ticker()
    |> Enum.find(fn entity ->
      Enum.find(entity[:tickers], fn t -> t == ticker end) ||
        Enum.find(entity[:tickers], fn t -> String.starts_with?(t, "#{ticker}-") end)
    end)
  end

  def formatted_entity(%{"entity" => entity, "tickers" => tickers}, id) do
    ticker_list = String.split(tickers, ",") |> Enum.map(&String.trim(&1))
    formatted_name = String.replace(entity, " (#{tickers})", "")

    %{
      name: formatted_name,
      tickers: ticker_list,
      cik: String.pad_leading(id, 10, "0")
    }
  end

  # for JSON-based apis this triplet of functions for parsing Finch responses
  # is usually all it takes (and copy/pasted across projects verbatim for the most part)
  defp parse_as_json({:ok, %Finch.Response{status: 200, body: body}}) do
    Jason.decode(body)
  end

  defp parse_as_json({:ok, %Finch.Response{status: error_code, body: body}}) do
    {:error, {:http, error_code, body}}
  end

  defp parse_as_json({:error, _exception} = error), do: error
end
