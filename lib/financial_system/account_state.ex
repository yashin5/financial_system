defmodule FinancialSystem.AccountState do
  use GenServer
  alias FinancialSystem.AccountDefinition, as: AccountDefinition
  alias FinancialSystem.Currency, as: Currency

  def start(state) do
    GenServer.start(__MODULE__, state)
  end
  def init(state) do
    {:ok, state}
  end

  def handle_call(:get_data, _, state) do
    {:reply, state, state}
  end

  def handle_cast({:deposit, value}, account) do
    {:noreply, %AccountDefinition{account | value: account.value + value}}
  end

  def handle_cast({:withdraw, value}, account) do
    {:noreply, %AccountDefinition{account | value: account.value - value}}
  end
end
