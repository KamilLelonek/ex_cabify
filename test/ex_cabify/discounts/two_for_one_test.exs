defmodule ExCabify.TwoForOneTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Discounts.TwoForOne, Basket, Storage.Product}

  @voucher_code "VOUCHER"
  @voucher_price 5
  @voucher %Product{code: @voucher_code, price: @voucher_price}

  test "should give two Vouchers for free" do
    products = [@voucher, @voucher, @voucher, @voucher, @voucher]

    assert 15 == TwoForOne.amount(%Basket{products: products})

    products = [@voucher, @voucher, @voucher, @voucher]

    assert 10 == TwoForOne.amount(%Basket{products: products})
  end

  test "should give one Voucher for free" do
    products = [@voucher, @voucher, @voucher]

    assert 10 == TwoForOne.amount(%Basket{products: products})

    products = [@voucher, @voucher]

    assert 5 == TwoForOne.amount(%Basket{products: products})
  end

  test "should not give any free Voucher" do
    products = [@voucher]

    assert 5 == TwoForOne.amount(%Basket{products: products})
  end

  test "should count other products with reduced price" do
    products = [
      @voucher,
      @voucher,
      @voucher,
      %Product{code: "MUG", price: 7.5},
      %Product{code: "TSHIRT", price: 20.0}
    ]

    assert 5.0 + 5.0 + 7.5 + 20.0 == TwoForOne.amount(%Basket{products: products})
  end

  test "should count other products without reduced price" do
    products = [
      @voucher,
      %Product{code: "MUG", price: 7.5}
    ]

    assert 7.5 + 5 == TwoForOne.amount(%Basket{products: products})
  end
end
