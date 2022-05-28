defmodule SecEdgar.Submissions do
  alias SecEdgar.DataAPI, as: API

  def get(cik) do
    cik
    |> String.pad_leading(10, "0")
    |> get_by_cik()
  end

  def get_by_cik(cik) do
    path_for_cik(cik)
    |> API.get_request()
    |> case do
      {:ok, body} ->
        body

      error_or_exception ->
        error_or_exception
    end
  end

  defp path_for_cik(cik) do
    "/submissions/CIK#{cik}.json"
  end
end
