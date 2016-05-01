defmodule Scantron.Worker do
  use Timex
  require Logger

  use Scantron.Persist.Database

  def start(result_set, {url, method} = method_url, params) do
    start_timestamp = Time.now
    {timestamp, {:ok, response}} = Time.measure(fn -> HTTPoison.get(url) end)
    %Result{
      result_set: result_set,
      method_url: method_url,
      start_time: start_timestamp,
      total_time: Time.to_msecs(timestamp),
      response_code: response.status_code,
      response_length: String.length response.body
    } |> Result.write!
    Time.to_msecs(timestamp)
  end


end
