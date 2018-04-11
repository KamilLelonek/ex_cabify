defmodule ExCabify.Storage.Product do
  @derive [Poison.Encoder]

  defstruct ~w(code name price)a
end
