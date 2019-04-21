defmodule FinancialSystem.SplitDefinition do
  @moduledoc """
  This module is responsable to define the struct for split transfers.
  """

  @enforce_keys [:account, :percent]

  defstruct [:account, :percent]
end
