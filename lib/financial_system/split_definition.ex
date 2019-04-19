defmodule FinancialSystem.SplitDefinition do

  @enforce_keys [:account, :percent]

  defstruct [:account, :percent]
end
