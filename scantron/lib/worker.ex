defmodule Scantron.Worker do
  use Timex
  require Logger

  use Scantron.Persist.Database

  def start(result_set, {url, method} = method_url, params) do
    start_timestamp = Time.now
    {timestamp, response} = Time.measure(fn -> HTTPoison.get(url, timeout: 30000) end)

    result = %Result{
      result_set: result_set,
      method_url: method_url,
      start_time: start_timestamp,
      total_time: Time.to_milliseconds(timestamp)
    }

    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        %{result | response_code: status_code, response_length: String.length body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        %{result | error_reason: reason}
    end |> Result.write!

    Time.to_milliseconds(timestamp)
  end
end
