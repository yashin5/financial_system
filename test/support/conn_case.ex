defmodule FinancialSystem.ConnCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      use FinancialSystem.DataCase
      use Plug.Test
    end
  end
end
