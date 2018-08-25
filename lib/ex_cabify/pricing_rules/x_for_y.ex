defmodule ExCabify.PricingRules.XForY do
  @derive [Poison.Encoder]

  @enforce_keys ~w(x y applicable_code)a

  defstruct @enforce_keys
end
