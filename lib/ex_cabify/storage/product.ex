defmodule ExCabify.Storage.Product do
  @derive [Poison.Encoder]

  defstruct code: "",
            name: "",
            price: 0
end
