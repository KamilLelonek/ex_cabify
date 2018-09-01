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

  describe "refine/2" do
    test "should refine codes based on XForY pricing rule" do
      code = "TSHIRT"
      old_price = 10
      discount = 2
      total = 3
      new_price = old_price * discount / total

      pricing_rule = %XForY{
        applicable_code: code,
        reduced_count: discount,
        applicable_count: total
      }

      products = [
        %Product{code: code, price: old_price},
        %Product{code: code, price: old_price},
        %Product{code: code, price: old_price}
      ]

      assert [
               %Product{code: ^code, price: ^new_price},
               %Product{code: ^code, price: ^new_price},
               %Product{code: ^code, price: ^new_price}
             ] = PricingRules.refine(pricing_rule, products)
    end

    test "should refine codes based on BulkPurchase pricing rule" do
      price = 10.0
      code = "VOUCHER"

      pricing_rule = %BulkPurchase{
        applicable_code: code,
        applicable_count: 2,
        reduced_prize: price
      }

      products = [
        %Product{code: code},
        %Product{code: code},
        %Product{code: code}
      ]

      assert [
               %Product{code: ^code, price: ^price},
               %Product{code: ^code, price: ^price},
               %Product{code: ^code, price: ^price}
             ] = PricingRules.refine(pricing_rule, products)
    end

    test "should refine codes based on both pricing rules" do
    end
  end
end
