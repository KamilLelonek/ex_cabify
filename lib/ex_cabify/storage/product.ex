defmodule ExCabify.Storage.Product do
  @derive [Poison.Encoder]

  @type t :: __MODULE__

  defstruct code: "",
            name: "",
            price: 0
end
