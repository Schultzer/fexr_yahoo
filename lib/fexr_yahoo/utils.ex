defmodule FexrYahoo.Utils do
  @moduledoc """
  Documentation for FexrYahoo.Utils.
  """

  @doc false
  @spec format(String.t, list(String.t)) :: map | no_return
  def format({:ok, json}, symbols) do
    json
    |> Poison.decode!
    |> extract_rates
    |> format_rates
    |> serialize
    |> map_merge
    |> filter(symbols)
  end

  @spec extract_rates(map) :: map
  def extract_rates(map), do: map["query"]["results"]["rate"]

  @spec format_rates(map) :: list({String.t, String.t, String.t, String.t})
  defp format_rates(nil), do: {:error, "no rates"}
  defp format_rates(rates), do: for rate <- rates, do: {rate["Name"], rate["Date"], rate["Time"], rate["Rate"]}

  @spec serialize({:error, String.t} | list({String.t, String.t, String.t, String.t})) :: {:error, String.t} | list(map)
  defp serialize({:error, reason}), do: {:error, reason}
  defp serialize(rates) do
    for {name, _date, _time, rate} <- rates do
      [base, symbol] = String.split(name, "/")
      %{symbol => String.to_float(rate)}
    end
  end

  @spec map_merge({:error, String.t}) :: {:error, String.t}
  defp map_merge({:error, reason}), do: {:error, reason}

  @spec map_merge(list(map), map) :: no_return | map
  defp map_merge(currencies, acc \\ %{})
  defp map_merge([], acc), do: acc
  defp map_merge([currency | currencies], acc), do: map_merge(currencies, Map.merge(currency, acc))

  @spec filter({:error, String.t}) :: {:error, String.t}
  defp filter({:error, reason}), do: {:error, reason}

  @spec filter(map, list | nil | list(String.t)) :: map
  defp filter(rates, []), do: rates
  defp filter(rates, nil), do: rates
  defp filter(rates, symbols), do: Map.take(rates, symbols)

  @spec convert_symbols(list(atom | String.t)) :: [] | list(String.t)
  def convert_symbols([]), do: []
  def convert_symbols(symbols) do
    {:ok, symbols
          |> Enum.reject(fn(s) -> not is_atom(s) and not is_binary(s) end)
          |> Enum.map(fn(s) -> if is_atom(s), do: Atom.to_string(s) |> String.upcase, else: String.upcase(s) end)}
  end
end
