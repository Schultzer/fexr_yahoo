defmodule FexrYahoo do
  require Logger

  defp query(base) do
    ConCache.get_or_store(:yahoo, "#{base}", fn ->
      base
      |> currencies
      |> url
      |> URI.encode
      |> fetch
      |> Poison.decode!
    end)
  end

  defp currencies(base) do
    for symbol <- Enum.reject(symbols, fn(iso) -> iso == base end) do
      '"#{base}#{symbol}",'
    end
    |> Enum.concat
    |> List.to_string
    |> String.trim_trailing(",")
  end

  def symbols do
    ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM",
     "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BRL", "BSD", "BTN",
     "BWP", "BYN", "BZD", "CAD", "CDF", "CHF", "CLP", "CNY", "COP", "CRC", "CUC",
     "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR",
     "FJD", "FKP", "GBP", "GEL", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD",
     "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IQD", "IRR", "ISK", "JMD",
     "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT",
     "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK",
     "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MYR", "MZN", "NAD", "NGN",
     "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN",
     "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK",
     "SGD", "SHP", "SLL", "SOS", "SRD", "STD", "SVC", "SYP", "SZL", "THB", "TJS",
     "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "UYU",
     "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XCD", "XDR", "XOF", "XPF", "YER",
     "ZAR", "ZMW", "ZWL"]
  end

  defp url(query) do
    "https://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in (#{query})&format=json&env=store://datatables.org/alltableswithkeys&callback="
  end

  defp fetch(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Code: 200 URL: #{url}"
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.info "Code: 404 URL: #{url}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error reason
    end
  end

  defp format(rates), do: for rate <- rates, do: {rate["Name"], rate["Date"], rate["Time"], rate["Rate"]}

  defp serialize(rates) do
    for {name, date, time, rate} <- rates, do: %{parse(name) => String.to_float(rate)}
  end

  defp parse(name), do: Enum.find(symbols, fn(code) -> String.ends_with?(name, code) end)

  defp map_merge(currencies, acc \\ %{})
  defp map_merge([], acc), do: acc
  defp map_merge([currency | currencies], acc), do: map_merge(currencies, Map.merge(currency, acc))

  defp filter(rates, []), do: rates
  defp filter(rates, nil), do: rates
  defp filter(rates, symbols), do: Map.take(rates, symbols)

  def convert_symbols([]), do: []
  def convert_symbols(symbols) do
    symbols
    |> Enum.reject(fn(s) -> not is_atom(s) and not is_binary(s) end)
    |> Enum.map(fn(s) -> if is_atom(s), do: Atom.to_string(s) |> String.upcase, else: String.upcase(s) end)
  end

  def rates({base, symbols}) do
    response = query(base)
    response["query"]["results"]["rate"]
    |> format
    |> serialize
    |> map_merge
    |> filter(symbols)
  end

  @moduledoc """
  Documentation for FexrYahoo.
  """

  @doc """
  returns a map with exchange rates,
  an options is provided to select symbols, default is set to all available symbols

  ## Examples

      iex> FexrYahoo.rates("USD", ["EUR"])
      %{"EUR" => 0.8491}

  """
  def rates(base, symbols \\ [])
  def rates(base, _symbols) when not is_atom(base) and not is_binary(base), do: raise ArgumentError, "base has to be an atom or binary #{base}"
  def rates(_base, symbols) when not is_list(symbols), do: raise ArgumentError, "symbols has to be a list #{symbols}"
  def rates(base, symbols) when is_atom(base), do: base |> Atom.to_string |> String.upcase |> rates(symbols)
  def rates(base, symbols) when is_list(symbols), do: rates({base, convert_symbols(symbols)})
end
