defmodule SecEdgar.Support.Fixtures.Common do
  def cik_123_submissions do
  end

  def request_rate_threshold_exceeded do
    {:ok, response_body} = File.read("#{__DIR__}/RequestRateThresholdExceeded.xhtml")

    {:error, {:http, 403, response_body}}
  end

  def submission(cik) do
    "#{__DIR__}/submissions/#{cik}.json"
    |> File.read!()
    |> Jason.decode!()
  end
end
