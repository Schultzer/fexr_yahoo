defmodule FexrYahoo do
  @moduledoc """
  Documentation for FexrYahoo.
  """

  @doc """
  Gets the exchange rate.
  an options is provided to select symbols, default is set to all available symbols

  ## Symbols
    * if used only returns exchange rates for the selected symbols

  ## Examples

      iex> FexrYahoo.rates("USD", ["EUR"])
      #=> {:ok, %{"EUR" => 0.8491}}

      iex> FexrYahoo.rates(:USD, [:EUR])
      #=> {:ok, %{"EUR" => 0.8491}}

  """
  @spec rates(String.t | atom, list(String.t | atom)) :: {:ok, map} | {:error, any} | no_return
  def rates(base, symbols \\ [])
  def rates(base, _symbols) when not is_atom(base) and not is_binary(base), do: {:error, "base has to be an atom or binary #{base}"}
  def rates(_base, symbols) when not is_list(symbols), do: {:error, "symbols has to be a list #{symbols}"}
  def rates(base, symbols) when is_atom(base), do: base |> Atom.to_string |> String.upcase |> rates(symbols)
  def rates(base, symbols) when is_list(symbols), do: get_for(base, FexrYahoo.Utils.convert_symbols(symbols))


  @doc """
  Gets the exchange rate. Raises on error.

  ## Symbols
    * if used only returns exchange rates for the selected symbols

  ## Examples

      iex> FexrYahoo.rates("USD", ["EUR"])
      #=> %{"EUR" => 0.8491}

      iex> FexrYahoo.rates(:USD, [:EUR])
      #=> %{"EUR" => 0.8491}

  """
  @spec rates!(String.t | atom, list(String.t | atom)) :: map | term
  def rates!(base, symbols \\ []) do
    case rates(base, symbols) do
      {:error, reason} -> raise reason
      {:ok, result}    -> result
    end
  end

  @strings ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM",
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

  @atoms [:AED, :AFN, :ALL, :AMD, :ANG, :AOA, :ARS, :AUD, :AWG, :AZN, :BAM,
          :BBD, :BDT, :BGN, :BHD, :BIF, :BMD, :BND, :BOB, :BRL, :BSD, :BTN,
          :BWP, :BYN, :BZD, :CAD, :CDF, :CHF, :CLP, :CNY, :COP, :CRC, :CUC,
          :CUP, :CVE, :CZK, :DJF, :DKK, :DOP, :DZD, :EGP, :ERN, :ETB, :EUR,
          :FJD, :FKP, :GBP, :GEL, :GHS, :GIP, :GMD, :GNF, :GTQ, :GYD, :HKD,
          :HNL, :HRK, :HTG, :HUF, :IDR, :ILS, :INR, :IQD, :IRR, :ISK, :JMD,
          :JOD, :JPY, :KES, :KGS, :KHR, :KMF, :KPW, :KRW, :KWD, :KYD, :KZT,
          :LAK, :LBP, :LKR, :LRD, :LSL, :LYD, :MAD, :MDL, :MGA, :MKD, :MMK,
          :MNT, :MOP, :MRO, :MUR, :MVR, :MWK, :MXN, :MYR, :MZN, :NAD, :NGN,
          :NIO, :NOK, :NPR, :NZD, :OMR, :PAB, :PEN, :PGK, :PHP, :PKR, :PLN,
          :PYG, :QAR, :RON, :RSD, :RUB, :RWF, :SAR, :SBD, :SCR, :SDG, :SEK,
          :SGD, :SHP, :SLL, :SOS, :SRD, :STD, :SVC, :SYP, :SZL, :THB, :TJS,
          :TMT, :TND, :TOP, :TRY, :TTD, :TWD, :TZS, :UAH, :UGX, :USD, :UYU,
          :UZS, :VEF, :VND, :VUV, :WST, :XAF, :XCD, :XDR, :XOF, :XPF, :YER,
          :ZAR, :ZMW, :ZWL]

  @doc """
  Lists all available symbols

  * option defults to `[as: :string]`

    - :string
    - :atom
  """
  @spec symbols([as: atom]) :: list(String.t) | list(atom)
  def symbols(options \\ [as: :string])
  def symbols([as: :string]), do: @strings
  def symbols([as: :atom]), do: @atoms

  @spec get_for(String.t, list(String.t)) :: no_return
  defp get_for(base, symbols) do
    case FexrYahoo.Request.fetch(base) do
      {:error, reason} -> {:error, reason}
      {:ok, result}    -> {:ok, FexrYahoo.Utils.format(result, symbols)}
    end
  end
end
