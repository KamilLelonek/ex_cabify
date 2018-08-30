defmodule ExCabify.Checkout do
  defstruct pricing_rules: [],
            codes: []

  alias ExCabify.{Storage.Repo, PricingRules}

  def new(pricing_rules \\ []),
    do: %__MODULE__{pricing_rules: pricing_rules}

  def scan(%__MODULE__{codes: codes} = checkout, code),
    do: %__MODULE__{checkout | codes: [code | codes]}

  def total(%__MODULE__{codes: codes, pricing_rules: pricing_rules}),
    do: Enum.reduce(pricing_rules, Repo.all_by_codes(codes), &PricingRules.refine/2)
end
