defmodule ExCabify.DiscountTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Discounts, Basket, Storage.Product}
  alias ExCabify.Discounts.{Bulk, TwoForOne}

  test "should not apply a Discount for an empty Basket" do
    refute Discounts.applies?(Bulk, %Basket{})
    refute Discounts.applies?(TwoForOne, %Basket{})
  end

  test "should not apply a Discount for not enough products" do
    refute Discounts.applies?(Bulk, %Basket{products: [%Product{code: "TSHIRT"}]})
    refute Discounts.applies?(TwoForOne, %Basket{products: [%Product{code: "VOUCHER"}]})
  end

  test "should not apply a Discount for not specific products" do
    refute Discounts.applies?(Bulk, %Basket{
             products: [
               %Product{code: "VOUCHER"},
               %Product{code: "VOUCHER"},
               %Product{code: "VOUCHER"}
             ]
           })

    refute Discounts.applies?(TwoForOne, %Basket{
             products: [
               %Product{code: "TSHIRT"},
               %Product{code: "TSHIRT"},
               %Product{code: "TSHIRT"}
             ]
           })
  end

  test "should apply a Discount" do
    assert Discounts.applies?(Bulk, %Basket{
             products: [
               %Product{code: "TSHIRT"},
               %Product{code: "TSHIRT"},
               %Product{code: "TSHIRT"}
             ]
           })

    assert Discounts.applies?(TwoForOne, %Basket{
             products: [
               %Product{code: "VOUCHER"},
               %Product{code: "VOUCHER"}
             ]
           })
  end
end
