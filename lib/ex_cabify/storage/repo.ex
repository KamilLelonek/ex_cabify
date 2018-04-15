defmodule ExCabify.Storage.Repo do
  alias ExCabify.Storage.Product

  @data :ex_cabify
        |> :code.priv_dir()
        |> Path.join("data.json")
        |> File.read!()
        |> Poison.decode!(keys: :atoms, as: [%Product{}])

  def all, do: @data

  def one(code), do: Enum.find(all(), &(&1.code == code))
end
