# FexrYahoo

FexrYahoo serve you the latest exchange rates from Yahoo exchange in a simple developer friendly map.

[![Build Status](https://travis-ci.org/Schultzer/fexr_yahoo.svg?branch=master)](https://travis-ci.org/Schultzer/fexr_yahoo)


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fexr_yahoo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fexr_yahoo, "~> 0.1.0"}
  ]
end
```

## Methods

### `rates/2`
returns a map with exchange rates,
an options is provided to select symbols, default is set to all available symbols

```elixir
FexrYahoo.rates(:USD) => %{"EUR" => 0.8491 ...}
FexrYahoo.rates("EUR", [:USD]) => %{"USD" => 1.1769}
```

## Documentation
[https://hexdocs.pm/fexr_yahoo](https://hexdocs.pm/fexr_yahoo)

## LICENSE

(The MIT License)

Copyright (c) 2017 Benjamin Schultzer

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
