defmodule FexrYahooTest do
  use ExUnit.Case

  test "rates/2" do
    rates = FexrYahoo.rates("USD", [:EUR])
    assert Map.keys(rates) == ["EUR"]

    rates = FexrYahoo.rates(:EUR, ["usd", "VND"])
    assert Map.keys(rates) == ["USD", "VND"]
  end

end
