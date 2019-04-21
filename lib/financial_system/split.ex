defmodule FinancialSystem.Split do
  @moduledoc """
  This module is responsable to define the struct for split transfers.
  """

  alias FinancialSystem.Account, as: Account

  @typedoc """
    Abstract split struct type.
  """
  @type t :: %__MODULE__{account: Account.t(), percent: number()}

  @enforce_keys [:account, :percent]

  defstruct [:account, :percent]
end
