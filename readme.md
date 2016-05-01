Scantron.Supervisor.init(:ok)
Amnesia.transaction do: Result.match([url: "https://esharesinc.com"])

List all:
  Enum.to_list(Result.stream!)

Add resource:
  %Resource{method_url: {"https://esharesinc.com", :get}, params: %{}} |> Resource.write!

Result.read!(1)

Create DB:
  mix amnesia.create -db Scantron.Persist.Database --disk
