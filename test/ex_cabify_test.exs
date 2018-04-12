defmodule ExCabifyTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Basket, Storage.Product, Discounts}

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

  describe "total/1" do
    test "should calculate the total price of scanned products when no pricing rules are given" do
      {:ok, scanner} = ExCabify.scan(%ExCabify{}, "VOUCHER")
      {:ok, scanner} = ExCabify.scan(scanner, "MUG")
      {:ok, scanner} = ExCabify.scan(scanner, "TSHIRT")

      assert 32.5 = ExCabify.total(scanner)
    end

    test "should calculate the total price based on Bulk pricing rule" do
      scanner = ExCabify.new(Discounts.Bulk)
      {:ok, scanner} = ExCabify.scan(scanner, "TSHIRT")
      {:ok, scanner} = ExCabify.scan(scanner, "TSHIRT")
      {:ok, scanner} = ExCabify.scan(scanner, "TSHIRT")

      assert 57.0 = ExCabify.total(scanner)
    end

    test "should calculate the total price based on TwoForOne pricing rule" do
      scanner = ExCabify.new(Discounts.TwoForOne)
      {:ok, scanner} = ExCabify.scan(scanner, "VOUCHER")
      {:ok, scanner} = ExCabify.scan(scanner, "VOUCHER")

      assert 5.0 = ExCabify.total(scanner)
    end
  end
end
