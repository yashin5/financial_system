defmodule ApiWeb.FallbackController do
  @moduledoc false


  use ApiWeb, :controller

  def call(conn, {:error, :invalid_account_id_type}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_account_id_type})
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

  def call(conn, {:error, :invalid_type_to_compare}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_type_to_compare})
  end

  def call(conn, {:error, :invalid_total_percent}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :invalid_total_percent})
  end

  def call(conn, {:error, :account_dont_exist}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :account_dont_exist})
  end

  def call(conn, {:error, :currency_is_not_valid}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :currency_is_not_valid})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ApiWeb.ErrorView)
    |> render("error.json", %{error: :not_found})
  end
end