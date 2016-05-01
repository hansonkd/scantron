defmodule Scantron.Supervisor do
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
  def init(:ok) do

    Amnesia.transaction do
      result_set = %ResultSet{start_time: Time.now} |> ResultSet.write

      total_time =

      Resource.stream
      |> Enum.map(fn(a) -> List.duplicate(a, 2) end)
      |> List.flatten
      |> Enum.shuffle
      |> Enum.map(&Task.async(fn -> Scantron.Worker.start(result_set.id, &1.method_url, &1.params) end))
      |> Enum.map(&Task.await/1)
      |> Enum.reduce(Aggregator.new, &Aggregator.add_result(&2, &1))
      |> Aggregator.value

      %{result_set | total_time: total_time} |> ResultSet.write
    end
  end


end
