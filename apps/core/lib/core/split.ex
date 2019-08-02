defmodule FinancialSystem.Core.Split do
  @moduledoc """
  This module is responsable to define the struct for split transfers.
  """

  alias FinancialSystem.Core.{Accounts.Account}

  @typedoc """
    Abstract split struct type.
  """
  @type t :: %__MODULE__{account: Account.t(), percent: number()}

  @derive {Jason.Encoder, only: [:account, :percent]}

  @enforce_keys [:account, :percent]

  defstruct [:account, :percent]
end
