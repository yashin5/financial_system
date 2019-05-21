
# FinancialSystem

[![CircleCI](https://circleci.com/gh/yashin5/financial_system/tree/master.svg?style=svg&circle-token=4ca2de8fde25b3b61f471504131221a03df5eb81)](https://circleci.com/gh/yashin5/financial_system/tree/master)

## Introduction
This app makes you able to create accounts to make financial operations like you will see in the next topics.


## Features
- Create account
- Show value in account
- Withdraw
- Deposit
- Transfer between accounts
- Split transfer

## Stack

##### This system was build with Elixir using ```mix new ``` end:
- [Elixir](https://github.com/elixir-lang/elixir) (v1.8.1)
- [Poison](https://github.com/devinus/poison) (To parse the HTTP Json response)
- [Decimal](https://github.com/ericmj/decimal) (To precision arithmetic)
- [UUID](https://github.com/zyro/elixir-uuid) (To generate ID to accounts)
- [MOX](https://github.com/plataformatec/mox) (To mocking tests)

## Get started
To run this project locally you need to have Elixir installed in your machine. After this, follow these steps:

1. Clone this repository:

        git clone git@github.com:yashin5/financial_system.git

2. Change to the project directory:

        cd financial_system

3. Install the dependencies:

        mix deps.get

4. Run the project:

        iex -S mix

## Useful commands
- mix test
- mix credo --strict
- mix coveralls
- mix dialyzer
- mix deps.get
- mix format
- iex -S mix

## Usage

##### Create user account

```elixir
{:ok, account1} = FinancialSystem.create("Yashin Santos",  "EUR", "220")
{:ok, account2} = FinancialSystem.create("Antonio Marcos", "BRL", "100")
{:ok, account3} = FinancialSystem.create("Mateus Mathias", "BRL", "100")
```
##### Show value in account

```elixir
FinancialSystem.show(account1.account_id)
```

##### Deposit into account

```elixir
FinancialSystem.deposit(account1.account_id, "USD", "10")
```

##### Withdraw from account

```elixir
FinancialSystem.withdraw(account1.account_id, "10")
```

##### Transfer between accounts

```elixir
FinancialSystem.transfer("20", account1.account_id, account2.account_id)
```

##### Split transfer

```elixir
list_to = [
  %FinancialSystem.Split{account: account2.account_id, percent: 25},
  %FinancialSystem.Split{account: account2.account_id, percent: 25},
  %FinancialSystem.Split{account: account3.account_id, percent: 50}
]

FinancialSystem.split(account1.account_id, list_to, "100")
```

## Reference
- [Elixir school](https://elixirschool.com/pt/)
- [O Guia de estilo elixir](https://github.com/gusaiani/elixir_style_guide/blob/master/README_ptBR.md)
- [The complete Elixir and Phoenix bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/learn/v4/t/lecture/5911740?start=540)
- [The Pragmatic Studio](https://pragmaticstudio.com/)
- [Exceptions are Evil](https://github.com/plataformatec/mox)
