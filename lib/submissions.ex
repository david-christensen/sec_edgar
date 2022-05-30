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

  def get_recent_filings(cik) do
    get_recent_filings(cik, fn _filing -> true end)
  end

  def get_recent_filings(cik, filter) do
    cik
    |> SecEdgar.Submissions.get()
    |> then(&group_filings_data(&1["filings"]["recent"]))
    |> Enum.filter(filter)
    |> Enum.map(&add_url(&1, cik))
  end

  defp group_filings_data(list) do
    group_filings_data(list, [])
  end

  defp group_filings_data(
         %{
           "acceptanceDateTime" => [],
           "accessionNumber" => [],
           "act" => [],
           "fileNumber" => [],
           "filingDate" => [],
           "filmNumber" => [],
           "form" => [],
           "isInlineXBRL" => [],
           "isXBRL" => [],
           "items" => [],
           "primaryDocDescription" => [],
           "primaryDocument" => [],
           "reportDate" => [],
           "size" => []
         },
         grouped_list
       ) do
    Enum.reverse(grouped_list)
  end

  defp group_filings_data(
         %{
           "acceptanceDateTime" => [acceptance_date_time | rem_acceptance_date_time_list],
           "accessionNumber" => [accession_number | rem_accession_number_list],
           "act" => [act | rem_act_list],
           "fileNumber" => [file_number | rem_file_number_list],
           "filingDate" => [filing_date | rem_filing_date_list],
           "filmNumber" => [film_number | rem_film_number_list],
           "form" => [form | rem_form_list],
           "isInlineXBRL" => [is_inline_xbrl | rem_is_inline_xbrl_list],
           "isXBRL" => [is_xbrl | rem_is_xbrl_list],
           "items" => [items | rem_items_list],
           "primaryDocDescription" => [primary_doc_description | rem_primary_doc_description_list],
           "primaryDocument" => [primary_document | rem_primary_document_list],
           "reportDate" => [report_date | rem_report_date_list],
           "size" => [size | rem_size_list]
         },
         grouped_list
       ) do
    grouped_item = %{
      "acceptanceDateTime" => acceptance_date_time,
      "accessionNumber" => accession_number,
      "act" => act,
      "fileNumber" => file_number,
      "filingDate" => filing_date,
      "filmNumber" => film_number,
      "form" => form,
      "isInlineXBRL" => is_inline_xbrl,
      "isXBRL" => is_xbrl,
      "items" => items,
      "primaryDocDescription" => primary_doc_description,
      "primaryDocument" => primary_document,
      "reportDate" => report_date,
      "size" => size
    }

    grouped_list = [grouped_item | grouped_list]

    rem_lists = %{
      "acceptanceDateTime" => rem_acceptance_date_time_list,
      "accessionNumber" => rem_accession_number_list,
      "act" => rem_act_list,
      "fileNumber" => rem_file_number_list,
      "filingDate" => rem_filing_date_list,
      "filmNumber" => rem_film_number_list,
      "form" => rem_form_list,
      "isInlineXBRL" => rem_is_inline_xbrl_list,
      "isXBRL" => rem_is_xbrl_list,
      "items" => rem_items_list,
      "primaryDocDescription" => rem_primary_doc_description_list,
      "primaryDocument" => rem_primary_document_list,
      "reportDate" => rem_report_date_list,
      "size" => rem_size_list
    }

    group_filings_data(rem_lists, grouped_list)
  end

  defp add_url(
         %{
           "acceptanceDateTime" => acceptance_date_time,
           "accessionNumber" => accession_number,
           "act" => act,
           "fileNumber" => file_number,
           "filingDate" => filing_date,
           "filmNumber" => film_number,
           "form" => form,
           "isInlineXBRL" => is_inline_xbrl,
           "isXBRL" => is_xbrl,
           "items" => items,
           "primaryDocDescription" => primary_doc_description,
           "primaryDocument" => primary_document,
           "reportDate" => report_date,
           "size" => size
         },
         cik
       ) do
    formatted_accession_number = accession_number |> String.split("-") |> Enum.join("")

    %{
      "acceptanceDateTime" => acceptance_date_time,
      "accessionNumber" => accession_number,
      "act" => act,
      "fileNumber" => file_number,
      "filingDate" => filing_date,
      "filmNumber" => film_number,
      "form" => form,
      "isInlineXBRL" => is_inline_xbrl,
      "isXBRL" => is_xbrl,
      "items" => items,
      "primaryDocDescription" => primary_doc_description,
      "primaryDocument" => primary_document,
      "reportDate" => report_date,
      "size" => size,
      "primary_document_url" =>
        "https://www.sec.gov/Archives/edgar/data/#{String.to_integer(cik)}/#{formatted_accession_number}/#{primary_document}",
      "filing_detail_url" =>
        "https://www.sec.gov/Archives/edgar/data/#{cik}/#{formatted_accession_number}/#{accession_number}-index.htm"
    }
  end

  defp path_for_cik(cik) do
    "/submissions/CIK#{cik}.json"
  end
end
