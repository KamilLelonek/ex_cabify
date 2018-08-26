defmodule ExCabify.Storage.Repo do
  alias ExCabify.Storage.Product

  @file_path :ex_cabify
             |> :code.priv_dir()
             |> Path.join("products.json")

  def all do
    @file_path
    |> File.read!()
    |> Poison.decode!(keys: :atoms, as: [%Product{}])
  end

  def one(code),
    do: Enum.find(all(), &(&1.code == code))

  def all_by_codes(codes),
    do: Enum.filter(all(), &(&1.code in codes))
end
