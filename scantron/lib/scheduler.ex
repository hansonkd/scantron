defmodule Scantron.Scheduler do
  use Timex

  use Scantron.Persist.Database

  defmodule Aggregator do
    def new, do: 0
    def value(aggregator), do: aggregator

    def add_result(aggregator, result) do
      :timer.sleep(50)
      aggregator + result
    end
  end

  defmodule RunningAverage do
    def new, do: {0, 0}
    def value({sum, num}), do: sum / num

    def add_result({sum, num}, result) do
      {sum + result, num + 1}
    end
  end

  def run_resources(num_dupicates \\ 1) do

    Amnesia.transaction do
      result_set = %ResultSet{start_time: Time.now} |> ResultSet.write

      total_time =

      Resource.stream
      |> Enum.map(fn(a) -> List.duplicate(a, num_dupicates) end)
      |> List.flatten
      |> Enum.shuffle
      |> Enum.map(&Task.async(fn -> Scantron.Worker.start(result_set.id, &1.method_url, &1.params) end))
      |> Enum.map(&Task.await/1)
      |> Enum.reduce(Aggregator.new, &Aggregator.add_result(&2, &1))
      |> Aggregator.value

      %{result_set | total_time: total_time} |> ResultSet.write
    end
  end

  def average_time(num_dupicates \\ 1) do
    result_set = run_resources(num_dupicates)

    Amnesia.transaction do
      Result.match([url: "https://esharesinc.com", result_set: result_set.id])
      |> Amnesia.Selection.values
      |> Enum.reduce(RunningAverage.new, &RunningAverage.add_result(&2, &1.total_time))
      |> RunningAverage.value
    end
  end

end
