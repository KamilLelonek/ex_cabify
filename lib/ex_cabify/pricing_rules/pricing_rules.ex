defmodule ExCabify.PricingRules do
  @wildcard :ex_cabify
            |> :code.priv_dir()
            |> Path.join("pricing_rules/*.json")

  alias ExCabify.PricingRules.Refinement

  def all(wildcard \\ @wildcard) do
    wildcard
    |> files()
    |> Enum.map(&File.read!/1)
    |> Enum.map(&Poison.decode!(&1, keys: :atoms))
    |> Enum.map(&to_struct/1)
  end

  def refine(pricing_rule, products) do
    pricing_rule
    |> applies?(products)
    |> maybe_refine(products, pricing_rule)
  end

  def applies?(pricing_rule = %{applicable_count: applicable_count}, products) do
    products
    |> Enum.count(&contains_products?(&1, pricing_rule))
    |> Kernel.>=(applicable_count)
  end

  defp files(wildcard),
    do: Path.wildcard(wildcard)

  defp to_struct(%{kind: kind} = pricing_rule) do
    "Elixir.ExCabify.PricingRules."
    |> Kernel.<>(kind)
    |> String.to_existing_atom()
    |> struct(pricing_rule)
  end

  defp contains_products?(%{code: code}, %{applicable_code: code}), do: true
  defp contains_products?(%{code: _code}, %{applicable_code: _applicable_code}), do: false

  defp maybe_refine(false, products, _pricing_rule), do: products

  defp maybe_refine(true, products, pricing_rule) do
    with {applicable, not_applicable} <- split(products, pricing_rule) do
      pricing_rule
      |> Refinement.run(applicable)
      |> Kernel.++(not_applicable)
    end
  end

  defp split(products, pricing_rule),
    do: Enum.split_with(products, &contains_products?(&1, pricing_rule))
end
