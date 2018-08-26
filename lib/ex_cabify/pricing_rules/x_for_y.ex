defmodule ExCabify.PricingRules.XForY do
  @derive [Poison.Encoder]

  @enforce_keys ~w(applicable_count reduced_count applicable_code)a

  defstruct @enforce_keys
end
