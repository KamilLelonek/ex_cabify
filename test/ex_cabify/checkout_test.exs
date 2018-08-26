defmodule ExCabify.CheckoutTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Checkout, PricingRules}

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

  test "should be initialized with PricingRules" do
    pricing_rules = PricingRules.all()

    assert %Checkout{pricing_rules: ^pricing_rules} = Checkout.new(pricing_rules)
  end
end
