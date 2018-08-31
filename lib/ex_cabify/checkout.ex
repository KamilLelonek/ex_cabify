defmodule ExCabify.Checkout do
  defstruct pricing_rules: [],
            codes: []

  alias ExCabify.{Storage.Repo, PricingRules}

  def new(pricing_rules \\ []),
    do: %__MODULE__{pricing_rules: pricing_rules}

  def scan(%__MODULE__{codes: codes} = checkout, code),
    do: %__MODULE__{checkout | codes: [code | codes]}

  def total(%__MODULE__{codes: codes, pricing_rules: pricing_rules}) do
    pricing_rules
    |> Enum.reduce(products(codes), &refine/2)
    |> Enum.reduce(0, &sum/2)
  end

  defp products(codes), do: Repo.all_by_codes(codes)

  defp refine(pricing_rule, products),
    do: PricingRules.refine(pricing_rule, products)

  defp sum(%{price: price}, sum), do: sum + price
end
