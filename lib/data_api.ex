defmodule SecEdgar.DataAPI do
  @callback get_request(String.t()) ::
              {:ok, %{} | {:error, {Integer.t(), String.t()}} | {:error, %{}}}

  def get_request(path), do: impl().get_request(path)

  defp impl,
    do: Application.get_env(:sec_edgar, :data_api_contract, SecEdgar.Clients.DataApi)
end
