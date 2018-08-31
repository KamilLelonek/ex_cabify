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

  describe "total/1" do
    test "should calculate the total price of scanned products when no pricing rules apply" do
      checkout = Checkout.new()

      checkout = Checkout.scan(checkout, "VOUCHER")
      checkout = Checkout.scan(checkout, "MUG")
      checkout = Checkout.scan(checkout, "TSHIRT")

      assert 32.5 = Checkout.total(checkout)
    end

    test "should calculate the total price based on Bulk pricing rule" do
      checkout = Checkout.new(PricingRules.all())

      checkout = Checkout.scan(checkout, "TSHIRT")
      checkout = Checkout.scan(checkout, "TSHIRT")
      checkout = Checkout.scan(checkout, "TSHIRT")

      assert 57.0 = Checkout.total(checkout)
    end

    test "should calculate the total price based on XForY pricing rule" do
      checkout = Checkout.new(PricingRules.all())

      checkout = Checkout.scan(checkout, "VOUCHER")
      checkout = Checkout.scan(checkout, "VOUCHER")

      assert 5.0 = Checkout.total(checkout)
    end

    test "should calculate the total price based on both pricing rules" do
      checkout = Checkout.new(PricingRules.all())

      checkout = Checkout.scan(checkout, "VOUCHER")
      checkout = Checkout.scan(checkout, "VOUCHER")
      checkout = Checkout.scan(checkout, "VOUCHER")
      checkout = Checkout.scan(checkout, "TSHIRT")
      checkout = Checkout.scan(checkout, "TSHIRT")
      checkout = Checkout.scan(checkout, "TSHIRT")

      assert 67.0 = Checkout.total(checkout)
    end
  end
end
