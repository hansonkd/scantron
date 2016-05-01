defmodule Scantron.Persist do
  @moduledoc false
  use Amnesia

  # defines a database called Database, it's basically a defmodule with
  # some additional magic
  defdatabase Database do
    @moduledoc false

    deftable Tag, [:method_url, :name], type: :bag do
      def get_resources(self) do
        Resource.read(self.key)
      end
    end

    deftable Resource, [:method_url, :params], type: :set do

      def add_tag(self, tag) do
        %Tag{method_url: self.method_url} |> Tag.write
      end

    end

    deftable ResultSet, [{ :id, autoincrement }, :start_time, :total_time], type: :ordered_set do

      def stats(self) do
        results = Result.read(self.id)

        %{
          "count" => Enum.count(results),
          "failed" => Enum.count(results),
          "time" => self.total_time,
         }
      end



    end

    deftable Result, [:result_set,
                     :method_url,
                     :start_time,
                     :total_time,
                     :response_code,
                     :error_reason,
                     :response_length], type: :bag, index: [:method_url] do
      def outliers do

      end

      def outliers_by_tag do

      end
    end

  end



end
