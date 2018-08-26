defmodule ExCabify.PricingRulesTest do
  use ExUnit.Case, async: true

  alias ExCabify.PricingRules
  alias ExCabify.PricingRules.{BulkPurchase, XForY}

  describe "all" do
    test "should read all PricingRules" do
      assert [
               %BulkPurchase{
                 applicable_code: "TSHIRT",
                 applicable_count: 3,
                 reduced_prize: 19.0
               },
               %XForY{
                 applicable_code: "VOUCHER",
                 applicable_count: 2,
                 reduced_count: 1
               }
             ] = PricingRules.all()
    end
  end

  describe "applies?(%{applicable_code: applicable_code, applicable_count: applicable_count}, codes)" do
    test "should not apply a Pricing rule when there are no enough codes" do
      pricing_rule = %{applicable_code: "TSHIRT", applicable_count: 2}
      codes = ["TSHIRT"]

      refute PricingRules.applies?(pricing_rule, codes)
    end

    test "should not apply a Pricing rule when there are no matching codes" do
      pricing_rule = %{applicable_code: "VOUCHER", applicable_count: 1}
      codes = ["TSHIRT", "TSHIRT"]

      refute PricingRules.applies?(pricing_rule, codes)
    end

    test "should apply a Pricing rule" do
      pricing_rule = %{applicable_code: "TSHIRT", applicable_count: 2}
      codes = ["TSHIRT", "TSHIRT"]

      assert PricingRules.applies?(pricing_rule, codes)
    end
  end
end
