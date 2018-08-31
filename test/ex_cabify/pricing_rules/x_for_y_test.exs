defmodule ExCabify.PricingRules.XForYTest do
  use ExUnit.Case, async: true

  alias ExCabify.PricingRules.XForY

  describe "new_price/2" do
    @old_price 30.0

    test "1 for 1" do
      pricing_rule = %XForY{applicable_count: 1, reduced_count: 1, applicable_code: ""}

      assert 30.0 = XForY.new_price(pricing_rule, @old_price)
    end

    test "2 for 1" do
      pricing_rule = %XForY{applicable_count: 2, reduced_count: 1, applicable_code: ""}

      assert 15.0 = XForY.new_price(pricing_rule, @old_price)
    end

    test "3 for 1" do
      pricing_rule = %XForY{applicable_count: 3, reduced_count: 1, applicable_code: ""}

      assert 10.0 = XForY.new_price(pricing_rule, @old_price)
    end

    test "3 for 2" do
      pricing_rule = %XForY{applicable_count: 3, reduced_count: 2, applicable_code: ""}

      assert 20.0 = XForY.new_price(pricing_rule, @old_price)
    end
  end
end
