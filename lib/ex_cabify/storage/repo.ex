defmodule ExCabify.Storage.Repo do
  alias ExCabify.Storage.Product

  @products :ex_cabify
            |> :code.priv_dir()
            |> Path.join("products.json")
            |> File.read!()
            |> Poison.decode!(keys: :atoms, as: [%Product{}])

  def all, do: @products

  def one(code), do: Enum.find(all(), &(&1.code == code))
end
