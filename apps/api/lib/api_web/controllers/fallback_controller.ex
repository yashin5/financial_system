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

  def call(conn, {:error, error})
      when error in [
             :invalid_value_type,
             :invalid_currency_type,
             :invalid_value_less_than_0,
             :invalid_arguments_type,
             :value_is_too_low_to_convert_to_the_currency
           ] do
    conn
    |> put_status(:bad_request)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: error})
  end

  def call(conn, {:error, error})
      when error in [
             :do_not_have_funds,
             :cannot_send_to_the_same,
             :invalid_total_percent,
             :user_dont_exist,
             :invalid_email_type,
             :invalid_email_or_password,
             :invalid_password_type,
             :currency_is_not_valid,
             :invalid_arguments,
             :contact_actual_name,
             :already_in_contacts
           ] do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: error})
  end

  def call(conn, {:error, error})
      when error in [:invalid_token_type, :season_expired, :token_dont_exist] do
    conn
    |> put_status(:unauthorized)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :unauthorized})
  end
end
