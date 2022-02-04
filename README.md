# SecEdgar

An elixir client library for the data.sec.gov API.

#### SEC EDGAR API Docs: https://www.sec.gov/edgar/sec-api-documentation

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sec_edgar` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sec_edgar, "~> 0.0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/sec_edgar>.

## Console Examples
#### FullTextSearch
```
iex -S mix
iex(1)> Finch.start_link(name: Edgar.Clients.FullTextSearch)
{:ok, #PID<0.249.0>}
iex(2)> {:ok, response} = Edgar.FullTextSearch.perform("BRK")
{:ok,
 %{
   "_shards" => %{
     "failed" => 0,
     "skipped" => 0,
     "successful" => 1,
     "total" => 1
   },
   "hits" => %{
     "hits" => [
       %{
         "_id" => "1067983",
         "_index" => "edgar_entity_20220120_162112",
         "_score" => 825.3616,
         "_source" => %{
           "entity" => "BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)",
           "entity_words" => "BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)",
           "rank" => 60010762,
           "tickers" => "BRK-B, BRK-A"
         },
         "_type" => "_doc"
       },
       %{
         "_id" => "1871638",
         "_index" => "edgar_entity_20220120_162112",
         "_score" => 36.834892,
         "_source" => %{
           "entity" => "BurTech Acquisition Corp. (BRKH, BRKHU)",
           "entity_words" => "BurTech Acquisition Corp. (BRKH, BRKHU)",
           "rank" => 5043420,
           "tickers" => "BRKH, BRKHU"
         },
         "_type" => "_doc"
       },
       ...
     ],
     "max_score" => 825.3616,
     "total" => %{"relation" => "eq", "value" => 9}
   },
   "query" => %{
     ...
     },
     "size" => 10
   },
   "timed_out" => false,
   "took" => 1
 }}
iex(3)> Enum.map(response["hits"]["hits"], &(&1["_source"]["entity"]))
["BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)",
 "BurTech Acquisition Corp. (BRKH, BRKHU)", "BRUKER CORP (BRKR)",
 "BROOKLINE BANCORP INC (BRKL)", "BRKR.IO, Inc.", "BRK Brands, Inc.",
 "Brkovich Davor", "Summer Street BRK Investors, LLC",
 "Robert Brkich Construction Corp."]
```

### Contributing
Bug reports and pull requests are welcome here on GitHub!

