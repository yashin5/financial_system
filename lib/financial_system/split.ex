defmodule FinancialSystem.Split do
  @moduledoc """
  This module is responsable to define the struct for split transfers.
  """

  alias FinancialSystem.{Accounts.AccountsRepo}

  @typedoc """
    Abstract split struct type.
  """
  @type t :: %__MODULE__{account: AccountsRepo.t(), percent: number()}

  @enforce_keys [:account, :percent]

  defstruct [:account, :percent]
end
