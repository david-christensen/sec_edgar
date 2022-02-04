defmodule Edgar.FullTextSearch do
  alias Edgar.Clients.FullTextSearch, as: FullTextSearchClient

  def perform(search_term) do
    FullTextSearchClient.perform(search_term) |> parse_as_json
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

