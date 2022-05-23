defmodule SecEdgar.Clients.FullTextSearch do
  def child_spec do
    {
      Finch,
      name: __MODULE__,
      pools: %{
        "https://efts.sec.gov/LATEST/search-index" => [size: pool_size()]
      }
    }
  end

  def pool_size, do: 25

  def perform(keys_typed), do: perform(keys_typed, true)

  def perform(keys_typed, narrow?) do
    build_body(keys_typed, narrow?)
    |> case do
      {:ok, body} ->
        :post
        |> Finch.build(
          "https://efts.sec.gov/LATEST/search-index",
          [{"Content-Type", "application/json"}],
          body
        )
        |> Finch.request(__MODULE__)

      error_or_exception ->
        error_or_exception
    end
  end

  defp build_body(keys_typed, false), do: build_body(keys_typed)

  defp build_body(keys_typed, true) do
    %{
      "keysTyped" => keys_typed,
      "narrow" => true
    }
    |> Jason.encode()
  end

  defp build_body(keys_typed) do
    %{
      "keysTyped" => keys_typed,
      "narrow" => false
    }
    |> Jason.encode()
  end
end
