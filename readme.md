Create DB:
  mix amnesia.create -db Scantron.Persist.Database --disk

use Scantron.Persist.Database

Add resource:
  %Resource{method_url: {"https://google.com", :get}, params: %{}} |> Resource.write!

Run Stress Test
  Scantron.Scheduler.run_resources()

Amnesia.transaction do
  Result.match([url: "https://google.com"])
end
List all from result set 1:
  Result.read!(1)
List all:
  Enum.to_list(Result.stream!)
