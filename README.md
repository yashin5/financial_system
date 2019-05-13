
# FinancialSystem

[![CircleCI](https://circleci.com/gh/yashin5/financial_system/tree/master.svg?style=svg&circle-token=4ca2de8fde25b3b61f471504131221a03df5eb81)](https://circleci.com/gh/yashin5/financial_system/tree/master)

## Features
- Create account
- Show value in account
- Deposit
- Transfer between accounts
- Split transfer

## Stack

##### This system was build with Elixir using ```mix new ```.
- [Elixir](https://github.com/elixir-lang/elixir)
- [Poison](https://github.com/devinus/poison)
- [Decimal](https://github.com/ericmj/decimal)

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
- mix docs
- mix deps.get
- mix format
- iex -S mix

## Usage

##### Create user account

```elixir
account1 = FinancialSystem.CreateAccount.create_user("Mario Freitas", "marios@email.com", "BRL", 100)
account2 = FinancialSystem.CreateAccount.create_user("Mario Marcelo", "mm@email.com", "USD", 100)
account3 = FinancialSystem.CreateAccount.create_user("Maria Julia", "mjulia@email.com", "EUR", 100)
account4 = FinancialSystem.CreateAccount.create_user("Fernando Francisco", "ff@email.com", "CZK", 100)
account5 = FinancialSystem.CreateAccount.create_user("Antonio Marques", "antonio@email.com", "BRL", 100)
```
##### Show value in account

```elixir
FinancialSystem.get_value_in_account(account1)
```

##### Deposit into account

```elixir
FinancialSystem.deposit(account1, "USD", 10)
```

##### Transfer between accounts

```elixir
FinancialSystem.transfer(account1, account2, 20)
```

##### Split transfer

```elixir
list_to = [
  %FinancialSystem.SplitList{account: account2, percent: 10},
  %FinancialSystem.SplitList{account: account2, percent: 10},
  %FinancialSystem.SplitList{account: account3, percent: 30},
  %FinancialSystem.SplitList{account: account4, percent: 40},
  %FinancialSystem.SplitList{account: account5, percent: 10},
]

FinancialSystem.split(account1, list_to, 100)
```

## Reference
- [Elixir school](https://elixirschool.com/pt/)
- [O Guia de estilo elixir](https://github.com/gusaiani/elixir_style_guide/blob/master/README_ptBR.md)
- [The complete Elixir and Phoenix bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/learn/v4/t/lecture/5911740?start=540)
