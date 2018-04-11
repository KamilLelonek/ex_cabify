defmodule ExCabify.Storage.Repo do
  alias ExCabify.Storage.Product

  @file_directory :code.priv_dir(:ex_cabify)
  @file_name "data.json"
  @file_path Path.join(@file_directory, @file_name)
  @file File.read!(@file_path)
  @options [keys: :atoms, as: [%Product{}]]
  @data Poison.decode!(@file, @options)

  def all, do: @data

  def one(code), do: Enum.find(all(), &(&1.code == code))
end
