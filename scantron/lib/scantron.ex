defmodule Scantron do
    use Application

    def start(_type, _args) do
      Scantron.Supervisor.start_link(:ok)
    end

end
