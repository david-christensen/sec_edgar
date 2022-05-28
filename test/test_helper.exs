ExUnit.start()

ExUnit.configure(exclude: :integration)

{:ok, _pid} = Finch.start_link(name: SecEdgar.Clients.FullTextSearch)
