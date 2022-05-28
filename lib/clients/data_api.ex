defmodule SecEdgar.Clients.DataApi do
  # TODO move to config file?
  @user_agent System.fetch_env!("SEC_EDGAR_USER_AGENT")

  def child_spec do
    {
      Finch,
      name: __MODULE__,
      pools: %{
        "https://data.sec.gov" => [size: pool_size()]
      }
    }
  end

  def pool_size, do: 25

  # TODO - this api can also return xml. For example:
  # <?xml version="1.0" encoding="UTF-8"?>
  # <Error>
  #     <Code>NoSuchKey</Code>
  #     <Message>The specified key does not exist.</Message>
  #     <Key>api/xbrl/companyfacts/CIK0000000000.json</Key>
  #     <RequestId>ZPWRGETYWFY204AD</RequestId>
  #     <HostId>iP/4HGVkR/0xvkVcsspk1D6z0zu/iuEd9hVSfbS2Y5OhE1zWA1Yuw4llmVAGHEWfhzjIVdMHllE=</HostId>
  # </Error>
  #
  def get_request(path) do
    :get
    |> Finch.build(
      "https://data.sec.gov#{path}",
      [
        {"User-Agent", @user_agent},
        {"Accept-Encoding", "gzip, deflate"},
        {"Host", "data.sec.gov"}
      ]
    )
    |> Finch.request(__MODULE__)
    |> parse_as_json()
  end

  # for JSON-based apis this triplet of functions for parsing Finch responses
  # is usually all it takes (and copy/pasted across projects verbatim for the most part)
  defp parse_as_json({:ok, %Finch.Response{status: 200, body: body}}) do
    :zlib.gunzip(body) |> Jason.decode()
  end

  defp parse_as_json({:ok, %Finch.Response{status: error_code, body: body}}) do
    {:error, {:http, error_code, :zlib.gunzip(body)}}
  end

  defp parse_as_json({:error, _exception} = error), do: error
end
