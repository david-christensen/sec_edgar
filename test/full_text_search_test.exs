defmodule SecEdgar.FullTextSearchTest do
  use ExUnit.Case
  doctest SecEdgar

  describe "list_for_ticker/1" do
    @tag :integration
    test "returns a list of entities for BRK" do
      list = SecEdgar.FullTextSearch.list_for_ticker("BRK")

      assert list == [
               %{
                 cik: "0001067983",
                 name: "BERKSHIRE HATHAWAY INC",
                 tickers: ["BRK-B", "BRK-A"]
               },
               %{
                 cik: "0001871638",
                 name: "BurTech Acquisition Corp.",
                 tickers: ["BRKH", "BRKHW", "BRKHU"]
               },
               %{cik: "0001109354", name: "BRUKER CORP", tickers: ["BRKR"]},
               %{cik: "0001049782", name: "BROOKLINE BANCORP INC", tickers: ["BRKL"]}
             ]
    end
  end

  describe "find_for_ticker/1" do
    @tag :integration
    test "returns a list of entities for BRK" do
      entity = SecEdgar.FullTextSearch.find_for_ticker("BRK")

      assert entity == %{
               cik: "0001067983",
               name: "BERKSHIRE HATHAWAY INC",
               tickers: ["BRK-B", "BRK-A"]
             }
    end
  end
end
