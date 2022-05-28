defmodule SecEdgar.SubmissionsTest do
  use ExUnit.Case
  doctest SecEdgar
  import Mox

  alias SecEdgar.SubmissionsMockData, as: MockData

  describe "SecEdgar.Submissions.get_by_cik/1" do
    test "returns a map response when request succeeds" do
      brk_cik = "0001067983"

      SecEdgar.MockDataAPI
      |> expect(:get_request, fn _path ->
        MockData.submission_response(brk_cik)
      end)

      result = SecEdgar.Submissions.get_by_cik(brk_cik)

      assert brk_cik == "000#{result["cik"]}"
    end

    test "returns error when invalid request is made" do
      SecEdgar.MockDataAPI
      |> expect(:get_request, fn _path ->
        MockData.bad_domain_error()
      end)

      result = SecEdgar.Submissions.get_by_cik("bad_domain_cik")
      assert {:error, %Mint.TransportError{reason: :nxdomain}} == result
    end

    test "returns an http error when one is recieved" do
      SecEdgar.MockDataAPI
      |> expect(:get_request, fn _path ->
        MockData.request_rate_threshold_exceeded()
      end)

      {:error, {:http, 403, _response_body}} =
        SecEdgar.Submissions.get_by_cik("request_rate_threshold_exceeded")
    end
  end
end
