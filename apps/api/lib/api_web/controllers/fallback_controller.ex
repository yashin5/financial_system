defmodule ApiWeb.FallbackController do
  @moduledoc false

  use ApiWeb, :controller
  import Ecto.Changeset

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors =
      traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: errors})
  end

  def call(conn, {:error, :invalid_value_type}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_value_type})
  end

  def call(conn, {:error, :invalid_currency_type}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_currency_type})
  end

  def call(conn, {:error, :invalid_arguments_type}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_arguments_type})
  end

  def call(conn, {:error, :invalid_value_less_than_0}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_value_less_than_0})
  end

  def call(conn, {:error, :do_not_have_funds}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :do_not_have_funds})
  end

  def call(conn, {:error, :cannot_send_to_the_same}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :cannot_send_to_the_same})
  end

  def call(conn, {:error, :invalid_total_percent}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_total_percent})
  end

  def call(conn, {:error, :user_dont_exist}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :user_dont_exist})
  end

  def call(conn, {:error, :invalid_email_type}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_email_type})
  end

  def call(conn, {:error, :invalid_email_or_password}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_email_or_password})
  end

  def call(conn, {:error, :currency_is_not_valid}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :currency_is_not_valid})
  end
end
