defmodule SecEdgar.SubmissionsMockData do
  def bad_domain_error do
    {:error, %Mint.TransportError{reason: :nxdomain}}
  end

  def request_rate_threshold_exceeded do
    {:ok, response_body} = File.read("#{__DIR__}/fixtures/RequestRateThresholdExceeded.xhtml")

    {:error, {:http, 403, response_body}}
  end

  def submission_response(cik) do
    "#{__DIR__}/fixtures/submissions/#{cik}.json"
    |> File.read!()
    |> Jason.decode!()
  end
end
