ExUnit.start()

ExUnit.configure(exclude: :integration)

{:ok, _pid} = Finch.start_link(name: SecEdgar.Clients.FullTextSearch)
# {:ok, _pid} = Finch.start_link(name: SecEdgar.Clients.DataApi)

# Set up mock for Auth0 API
Mox.defmock(SecEdgar.MockDataAPI, for: SecEdgar.DataAPI)
Application.put_env(:sec_edgar, :data_api_contract, SecEdgar.MockDataAPI)
