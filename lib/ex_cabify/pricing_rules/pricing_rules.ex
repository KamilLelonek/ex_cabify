defmodule ExCabify.PricingRules do
  @wildcard :ex_cabify
            |> :code.priv_dir()
            |> Path.join("pricing_rules/*.json")

  def all(wildcard \\ @wildcard) do
    wildcard
    |> files()
    |> Enum.map(&File.read!/1)
    |> Enum.map(&Poison.decode!(&1, keys: :atoms))
    |> Enum.map(&to_struct/1)
  end

  def applies?(%{applicable_code: applicable_code, applicable_count: applicable_count}, codes),
    do: Enum.count(codes, &(&1 == applicable_code)) >= applicable_count

  defp files(wildcard),
    do: Path.wildcard(wildcard)

  defp to_struct(%{kind: kind} = pricing_rule) do
    "Elixir.ExCabify.PricingRules."
    |> Kernel.<>(kind)
    |> String.to_existing_atom()
    |> struct(pricing_rule)
  end
end
