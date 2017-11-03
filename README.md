# FexrYahoo

FexrYahoo serve you the latest exchange rates from Yahoo exchange in a simple developer friendly map.

[![Build Status](https://travis-ci.org/Schultzer/fexr_yahoo.svg?branch=master)](https://travis-ci.org/Schultzer/fexr_yahoo)


# DEPRECATION WARNING!
[Yahoo](https://yahoo.com) has deprecated there finance api so this library will not work.

`"It has come to our attention that this service is being used in violation of the Yahoo Terms of Service.  As such, the service is being discontinued.  For all future markets and equities data research, please refer to finance.yahoo.com."`

[Download-Currency-Rates-Error-999](https://forums.yahoo.net/t5/Yahoo-Finance-help/Download-Currency-Rates-Error-999/m-p/387671/highlight/true#M6211)


## Examples

```elixir
    iex> FexrYahoo.rates("USD", ["EUR"])
    #=> {:ok, %{"EUR" => 0.8491}}

    iex> FexrYahoo.rates!(:USD, [:EUR])
    #=> %{"EUR" => 0.8491}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fexr_yahoo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fexr_yahoo, "~> 0.2.1"}
  ]
end
```

## Documentation
[https://hexdocs.pm/fexr_yahoo](https://hexdocs.pm/fexr_yahoo)

## LICENSE

(The MIT License)

Copyright (c) 2017 Benjamin Schultzer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
