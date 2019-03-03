defmodule FinancialSystem.Account do
  @moduledoc """
  This module make a struct for the user account.
  """

  defstruct [:name, :email, :currency, :value]
end
