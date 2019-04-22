# FinancialSystem

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
{_, pid} = FinancialSystem.create("Mario Freitas", "BRL", 100)
{_, pid2} = FinancialSystem.create("Mario Marcelo", "USD", 100)
{_, pid3} = FinancialSystem.create("Maria Julia", "EUR", 100)
{_, pid4} = FinancialSystem.create("Fernando Francisco", "CZK", 100)
{_, pid5} = FinancialSystem.create("Antonio Marques", "BRL", 100)
```
##### Show value in account

```elixir
FinancialSystem.show(pid)
```

##### Deposit into account

```elixir
FinancialSystem.deposit(pid, "USD", 1)
```

##### Transfer between accounts

```elixir
FinancialSystem.transfer(pid, pid2, 10)
```

##### Split transfer

```elixir
list_to = [
  %FinancialSystem.Split{account: pid2, percent: 20},
  %FinancialSystem.Split{account: pid3, percent: 10},
  %FinancialSystem.Split{account: pid4, percent: 30},
  %FinancialSystem.Split{account: pid5, percent: 40}
]

FinancialSystem.split(pid, list_to, 100)
```

## Reference
- [Elixir school](https://elixirschool.com/pt/)
- [O Guia de estilo elixir](https://github.com/gusaiani/elixir_style_guide/blob/master/README_ptBR.md)
- [The complete Elixir and Phoenix bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/learn/v4/t/lecture/5911740?start=540)
