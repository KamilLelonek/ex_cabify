defmodule ExCabify.DiscountTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Discounts, Basket, Storage.Product}

  alias ExCabify.Discounts.{TwoForOne, Bulk}

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
