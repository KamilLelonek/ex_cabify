defmodule ExCabify.BulkTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Discounts, Discounts.Bulk, Basket, Storage.Product}

  @tshirt_code "TSHIRT"
  @tshirt_price 100
  @tshirt %Product{code: @tshirt_code, price: @tshirt_price}

  test "should consider a reduced price" do
    products = [@tshirt, @tshirt, @tshirt, @tshirt]

    assert Bulk.reduced_price() * Enum.count(products) ==
             Discounts.apply(%Basket{products: products}, Bulk)
  end

  test "should not consider a reduced price" do
    products = [@tshirt, @tshirt]

    assert @tshirt_price * Enum.count(products) ==
             Discounts.apply(%Basket{products: products}, Bulk)
  end

  test "should count other products with reduced price" do
    products = [
      %Product{code: "VOUCHER", price: 5.0},
      %Product{code: "MUG", price: 7.5},
      @tshirt,
      @tshirt,
      @tshirt
    ]

    basket = %Basket{products: products}
    tshirts_count = Enum.count(products, &(&1.code == @tshirt_code))

    assert Bulk.reduced_price() * tshirts_count + 5.0 + 7.5 == Discounts.apply(basket, Bulk)
  end

  test "should count other products without reduced price" do
    products = [
      %Product{code: "VOUCHER", price: 5.0},
      %Product{code: "VOUCHER", price: 5.0},
      %Product{code: "VOUCHER", price: 5.0},
      @tshirt,
      @tshirt
    ]

    basket = %Basket{products: products}
    tshirts_count = Enum.count(products, &(&1.code == @tshirt_code))

    assert @tshirt_price * tshirts_count + 5.0 + 5.0 + 5.0 == Discounts.apply(basket, Bulk)
  end
end
