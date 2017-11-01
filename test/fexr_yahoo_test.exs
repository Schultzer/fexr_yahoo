defmodule FexrYahooTest do
  use ExUnit.Case

  @rates """
         {\"query\":{\"count\":10,\"created\":\"2017-11-01T04:56:02Z\",\"lang\":\"en-US\",\"results\":{\"rate\":[{\"id\":\"USDAED\",\"Name\":\"USD/AED\",\"Rate\":\"3.6725\",\"Date\":\"11/1/2017\",\"Time\":\"4:55am\",\"Ask\":\"3.6730\",\"Bid\":\"3.6725\"},{\"id\":\"USDAOA\",\"Name\":\"USD/AOA\",\"Rate\":\"165.0970\",\"Date\":\"10/31/2017\",\"Time\":\"11:00pm\",\"Ask\":\"166.7480\",\"Bid\":\"165.0970\"},{\"id\":\"USDBHD\",\"Name\":\"USD/BHD\",\"Rate\":\"0.3768\",\"Date\":\"11/1/2017\",\"Time\":\"4:53am\",\"Ask\":\"0.3770\",\"Bid\":\"0.3768\"},{\"id\":\"USDBWP\",\"Name\":\"USD/BWP\",\"Rate\":\"10.4992\",\"Date\":\"10/31/2017\",\"Time\":\"9:00am\",\"Ask\":\"10.5092\",\"Bid\":\"10.4992\"},{\"id\":\"USDCNY\",\"Name\":\"USD/CNY\",\"Rate\":\"6.6212\",\"Date\":\"11/1/2017\",\"Time\":\"4:55am\",\"Ask\":\"6.6222\",\"Bid\":\"6.6212\"},{\"id\":\"USDHUF\",\"Name\":\"USD/HUF\",\"Rate\":\"267.2400\",\"Date\":\"11/1/2017\",\"Time\":\"4:56am\",\"Ask\":\"267.4400\",\"Bid\":\"267.2400\"},{\"id\":\"USDUSD\",\"Name\":\"USD/USD\",\"Rate\":\"1.0000\",\"Date\":\"N/A\",\"Time\":\"N/A\",\"Ask\":\"1.0000\",\"Bid\":\"1.0000\"},{\"id\":\"USDVUV\",\"Name\":\"USD/VUV\",\"Rate\":\"106.1900\",\"Date\":\"11/1/2017\",\"Time\":\"3:54am\",\"Ask\":\"108.1900\",\"Bid\":\"106.1900\"},{\"id\":\"USDYER\",\"Name\":\"USD/YER\",\"Rate\":\"249.9500\",\"Date\":\"11/1/2017\",\"Time\":\"3:40am\",\"Ask\":\"250.0500\",\"Bid\":\"249.9500\"},{\"id\":\"USDZWL\",\"Name\":\"USD/ZWL\",\"Rate\":\"322.3550\",\"Date\":\"6/30/2016\",\"Time\":\"11:13pm\",\"Ask\":\"325.5800\",\"Bid\":\"322.3550\"}]}}}
         """
  @no_rates "{\"query\":{\"count\":0,\"created\":\"2017-11-01T04:53:56Z\",\"lang\":\"en-US\",\"results\":null}}"

  @formatted_rates %{"AED" => 3.6725, "AOA" => 165.097, "BHD" => 0.3768, "BWP" => 10.4992,
                     "CNY" => 6.6212, "HUF" => 267.24, "USD" => 1.0, "VUV" => 106.19,
                     "YER" => 249.95, "ZWL" => 322.355}

  test "rates!/2" do
    rates = FexrYahoo.rates!("USD", [:EUR])
    assert Map.keys(rates) == ["EUR"]

    rates = FexrYahoo.rates!(:EUR, ["usd", "VND"])
    assert Map.keys(rates) == ["USD", "VND"]
  end

  describe "format/2" do
    test "returns error when no rates" do
      FexrYahoo.Utils.format(@no_rates, []) == {:error, "no rates"}
    end

    test "returns formatted map when there is rates" do
      FexrYahoo.Utils.format(@rates, []) == @formatted_rates
    end
  end
end
