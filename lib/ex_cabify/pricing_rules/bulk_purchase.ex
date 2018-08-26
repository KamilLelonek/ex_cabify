defmodule ExCabify.PricingRules.BulkPurchase do
  @derive [Poison.Encoder]

  @enforce_keys ~w(applicable_count reduced_prize applicable_code)a

  defstruct @enforce_keys
end
