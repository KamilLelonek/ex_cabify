defmodule ExCabify.Storage.Product do
  @derive [Poison.Encoder]

  @type t :: __MODULE__

  defstruct code: "",
            name: "",
            price: 0

  def update_price(%__MODULE__{} = product, new_price),
    do: %__MODULE__{product | price: new_price}
end
