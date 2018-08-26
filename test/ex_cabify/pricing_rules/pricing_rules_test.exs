defmodule ExCabify.PricingRulesTest do
  use ExUnit.Case, async: true

  alias ExCabify.{PricingRules, Storage.Product}
  alias ExCabify.PricingRules.{BulkPurchase, XForY}

  describe "all/0" do
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

  describe "applies?/2" do
    test "should not apply a Pricing rule when there are no enough products" do
      pricing_rule = %{applicable_code: "TSHIRT", applicable_count: 2}
      products = [%Product{code: "TSHIRT"}]

      refute PricingRules.applies?(pricing_rule, products)
    end

    test "should not apply a Pricing rule when there are no matching products" do
      pricing_rule = %{applicable_code: "VOUCHER", applicable_count: 1}
      products = [%Product{code: "TSHIRT"}, %Product{code: "TSHIRT"}]

      refute PricingRules.applies?(pricing_rule, products)
    end

    test "should apply a Pricing rule" do
      pricing_rule = %{applicable_code: "TSHIRT", applicable_count: 2}
      products = [%Product{code: "TSHIRT"}, %Product{code: "TSHIRT"}]

      assert PricingRules.applies?(pricing_rule, products)
    end
  end
end
