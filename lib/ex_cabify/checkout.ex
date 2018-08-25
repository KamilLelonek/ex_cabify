defmodule ExCabify.Checkout do
  defstruct pricing_rules: [], codes: []

  def new(pricing_rules \\ []),
    do: %__MODULE__{pricing_rules: pricing_rules}

  def scan(%__MODULE__{codes: codes} = checkout, code),
    do: %__MODULE__{checkout | codes: [code | codes]}
end
