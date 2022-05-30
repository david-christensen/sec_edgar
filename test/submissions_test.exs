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

  describe "SecEdgar.Submissions.get_recent_filings/1" do
    test "returns a map response when request succeeds" do
      brk_cik = "0001067983"

      SecEdgar.MockDataAPI
      |> expect(:get_request, fn _path ->
        MockData.submission_response(brk_cik)
      end)

      filings = SecEdgar.Submissions.get_recent_filings(brk_cik)

      [first_filing | _rest] = filings

      assert first_filing == %{
               "acceptanceDateTime" => "2022-05-27T17:07:33.000Z",
               "accessionNumber" => "0001193125-22-162468",
               "act" => "34",
               "fileNumber" => "001-14905",
               "filingDate" => "2022-05-27",
               "filing_detail_url" =>
                 "https://www.sec.gov/Archives/edgar/data/0001067983/000119312522162468/0001193125-22-162468-index.htm",
               "filmNumber" => "22978826",
               "form" => "SD",
               "isInlineXBRL" => 0,
               "isXBRL" => 0,
               "items" => "",
               "primaryDocDescription" => "SD",
               "primaryDocument" => "d322277dsd.htm",
               "primary_document_url" =>
                 "https://www.sec.gov/Archives/edgar/data/1067983/000119312522162468/d322277dsd.htm",
               "reportDate" => "",
               "size" => 32115
             }
    end
  end

  describe "SecEdgar.Submissions.get_recent_filings/2" do
    test "returns a map response when request succeeds" do
      brk_cik = "0001067983"

      SecEdgar.MockDataAPI
      |> expect(:get_request, fn _path ->
        MockData.submission_response(brk_cik)
      end)

      filings =
        SecEdgar.Submissions.get_recent_filings(brk_cik, fn filing ->
          filing["form"] == "SC 13G"
        end)

      [first_filing | _rest] = filings

      assert first_filing == %{
               "acceptanceDateTime" => "2022-05-25T16:02:00.000Z",
               "accessionNumber" => "0001193125-22-159669",
               "act" => "",
               "fileNumber" => "",
               "filingDate" => "2022-05-25",
               "filing_detail_url" =>
                 "https://www.sec.gov/Archives/edgar/data/0001067983/000119312522159669/0001193125-22-159669-index.htm",
               "filmNumber" => "",
               "form" => "SC 13G",
               "isInlineXBRL" => 0,
               "isXBRL" => 0,
               "items" => "",
               "primaryDocDescription" => "SC 13G",
               "primaryDocument" => "d355075dsc13g.htm",
               "primary_document_url" =>
                 "https://www.sec.gov/Archives/edgar/data/1067983/000119312522159669/d355075dsc13g.htm",
               "reportDate" => "",
               "size" => 451_857
             }
    end
  end
end
