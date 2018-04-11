defmodule ExCabifyTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Basket, Storage.Product}

  describe "scan/2" do
    test "should not scan an unknown Product" do
      assert {:error, :product_not_found} = ExCabify.scan(%ExCabify{}, "unknown")
    end

    test "should scan an known Product" do
      assert {
               :ok,
               %ExCabify{
                 basket: %Basket{
                   products: [
                     %Product{
                       code: "VOUCHER",
                       name: "Cabify Voucher",
                       price: 5.0
                     }
                   ]
                 }
               }
             } = ExCabify.scan(%ExCabify{}, "VOUCHER")
    end
  end
end
