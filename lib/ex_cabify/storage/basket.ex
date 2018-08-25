defmodule ExCabify.Storage.Basket do
  alias ExCabify.Storage.Product
  alias __MODULE__

  @type t :: __MODULE__

  defstruct products: []

  def new, do: %Basket{}

  def put(%Basket{products: products} = basket, %Product{} = product),
    do: %Basket{basket | products: [product | products]}
end
