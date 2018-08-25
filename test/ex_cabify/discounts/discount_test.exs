defmodule ExCabify.DiscountTest do
  use ExUnit.Case, async: true

  alias ExCabify.Discounts
  alias ExCabify.Discounts.{TwoForOne, Bulk}
  alias ExCabify.Storage.{Basket, Product}

  describe "applies?/2" do
    test "should not apply a Discount for an empty Basket" do
      refute Discounts.applies?(%Basket{}, Bulk)
      refute(Discounts.applies?(%Basket{}, TwoForOne))
    end

    test "should not apply a Discount for not enough products" do
      refute Discounts.applies?(%Basket{products: [%Product{code: "TSHIRT"}]}, Bulk)
      refute(Discounts.applies?(%Basket{products: [%Product{code: "VOUCHER"}]}, TwoForOne))
    end

    test "should not apply a Discount for not specific products" do
      refute Discounts.applies?(
               %Basket{
                 products: [
                   %Product{code: "VOUCHER"},
                   %Product{code: "VOUCHER"},
                   %Product{code: "VOUCHER"}
                 ]
               },
               Bulk
             )

      refute Discounts.applies?(
               %Basket{
                 products: [
                   %Product{code: "TSHIRT"},
                   %Product{code: "TSHIRT"},
                   %Product{code: "TSHIRT"}
                 ]
               },
               TwoForOne
             )
    end

    test "should apply a Discount" do
      assert Discounts.applies?(
               %Basket{
                 products: [
                   %Product{code: "TSHIRT"},
                   %Product{code: "TSHIRT"},
                   %Product{code: "TSHIRT"}
                 ]
               },
               Bulk
             )

      assert Discounts.applies?(
               %Basket{
                 products: [
                   %Product{code: "VOUCHER"},
                   %Product{code: "VOUCHER"}
                 ]
               },
               TwoForOne
             )
    end
  end

  describe "apply/2" do
    test "should apply Bulk discount" do
      assert 19 * 3 ==
               Discounts.apply(
                 %Basket{
                   products: [
                     %Product{code: "TSHIRT"},
                     %Product{code: "TSHIRT"},
                     %Product{code: "TSHIRT"}
                   ]
                 },
                 Bulk
               )
    end

    test "should apply TwoForOne discount" do
      assert 100 ==
               Discounts.apply(
                 %Basket{
                   products: [
                     %Product{code: "VOUCHER", price: 100},
                     %Product{code: "VOUCHER", price: 100}
                   ]
                 },
                 TwoForOne
               )
    end
  end
end
