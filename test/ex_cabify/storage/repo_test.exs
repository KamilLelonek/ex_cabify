defmodule ExCabify.Storage.RepoTest do
  use ExUnit.Case, async: true

  alias ExCabify.Storage.{Repo, Product}

  describe "all/0" do
    test "should load all Products from JSON file" do
      assert [
               %Product{
                 code: "VOUCHER",
                 name: "Cabify Voucher",
                 price: 5.0
               },
               %Product{
                 code: "TSHIRT",
                 name: "Cabify T-Shirt",
                 price: 20.0
               },
               %Product{
                 code: "MUG",
                 name: "Cafify Coffee Mug",
                 price: 7.5
               }
             ] = Repo.all()
    end
  end

  describe "one/1" do
    test "should load one Product by its code" do
      code = "MUG"

      assert %Product{code: ^code} = Repo.one(code)
    end
  end
end
