defmodule FexrYahoo.Request do
  @moduledoc """
  Documentation for FexrYahoo.Request.
  """

  @doc false
  @spec fetch(String.t) :: no_return
  def fetch(base) do
    ConCache.get_or_store(:yahoo, "#{base}", fn ->
      base
      |> build_query
      |> build_url
      |> URI.encode
      |> request
    end)
  end

  @spec build_query(String.t) :: String.t
  defp build_query(base) do
    for symbol <- FexrYahoo.symbols do
      '"#{base}#{symbol}",'
    end
    |> Enum.concat
    |> List.to_string
    |> String.trim_trailing(",")
  end

  @spec build_url(String.t) :: String.t
  defp build_url(query) do
    "https://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in (#{query})&format=json&env=store://datatables.org/alltableswithkeys&callback="
  end

  @spec request(String.t) :: no_return
  defp request(url) do
    url
    |> HTTPoison.get
    |> handle_resp
  end

  @spec handle_resp({atom, %HTTPoison.Error{} | %HTTPoison.Response{}}) :: {:error, {atom, any}} | {:error, keyword} | no_return
  defp handle_resp({:error, %HTTPoison.Error{reason: reason}}), do: {:error, {:reason, reason}}
  defp handle_resp({:ok, %HTTPoison.Response{status_code: 404, request_url: url}}), do: {:error, status_code: 404, request_url: url}
  defp handle_resp({:ok, %HTTPoison.Response{status_code: 401, request_url: url}}), do: {:error, status_code: 401, request_url: url}
  defp handle_resp({:ok, %HTTPoison.Response{status_code: 200, body: json, headers: headers}}) do
    content_type = {"Content-Type", "application/json;charset=utf-8"}
    case Enum.member? headers, content_type do
      true  -> {:ok, json}
      false -> {:error, "No header #{inspect content_type} in #{inspect headers}"}
    end
  end
end
