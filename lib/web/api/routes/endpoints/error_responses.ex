defmodule FinancialSystem.Web.Api.Routes.Endpoints.ErrorResponses do
  def handle_error({:error, :invalid_account_id_type}) do
    %{response_status: 422, msg: :invalid_account_id_type}
  end

  def handle_error({:error, :invalid_value_type}) do
    %{response_status: 422, msg: :invalid_value_type}
  end

  def handle_error({:error, :invalid_currency_type}) do
    %{response_status: 422, msg: :invalid_currency_type}
  end

  def handle_error({:error, :invalid_arguments_type}) do
    %{response_status: 422, msg: :invalid_arguments_type}
  end

  def handle_error({:error, :invalid_split_list_type}) do
    %{response_status: 422, msg: :invalid_split_list_type}
  end

  def handle_error({:error, :invalid_value_less_than_0}) do
    %{response_status: 422, msg: :invalid_value_less_than_0}
  end

  def handle_error({:error, :invalid_operation_type}) do
    %{response_status: 422, msg: :invalid_operation_type}
  end

  def handle_error({:error, :do_not_have_funds}) do
    %{response_status: 422, msg: :do_not_have_funds}
  end

  def handle_error({:error, :cannot_send_to_the_same}) do
    %{response_status: 422, msg: :cannot_send_to_the_same}
  end

  def handle_error({:error, :invalid_type_to_compare}) do
    %{response_status: 422, msg: :invalid_type_to_compare}
  end

  def handle_error({:error, :invalid_total_percent}) do
    %{response_status: 422, msg: :invalid_total_percent}
  end

  def handle_error({:error, :account_dont_exist}) do
    %{response_status: 422, msg: :account_dont_exist}
  end

  def handle_error({:error, :currency_is_not_valid}) do
    %{response_status: 422, msg: :currency_is_not_valid}
  end

  def handle_error(response), do: response
end
