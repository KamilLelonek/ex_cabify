defmodule ExCabify do
  alias ExCabify.{Basket, Storage.Repo}

  defstruct pricing_rules: nil, basket: %Basket{}

  def scan(%ExCabify{} = scanner, code) do
    code
    |> Repo.one()
    |> maybe_add(scanner)
  end

  defp maybe_add(nil, _scanner), do: {:error, :product_not_found}

  defp maybe_add(product, %ExCabify{basket: basket} = scanner),
    do: {:ok, %ExCabify{scanner | basket: Basket.put(basket, product)}}
end
