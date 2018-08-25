defmodule ExCabify.CheckoutTest do
  use ExUnit.Case, async: true

  alias ExCabify.Checkout

  test "should have no codes after creating" do
    assert %Checkout{codes: []} = Checkout.new()
  end

  test "should scan new codes" do
    product_1 = "a"
    product_2 = "b"
    checkout = Checkout.new()

    checkout = Checkout.scan(checkout, product_1)

    assert %Checkout{codes: [^product_1]} = checkout
    assert %Checkout{codes: [^product_2, ^product_1]} = Checkout.scan(checkout, product_2)
  end
end
