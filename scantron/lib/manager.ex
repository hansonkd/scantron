defmodule Scantron.Manager do
    use GenServer

    use Scantron.Persist.Database

    def add_resource(self_pid, url, method, params) do
      %Resource{method_url: {url, method}, params: params}
    end

    def get_urls(self_pid) do

    end

    def make_job() do

    end
end
