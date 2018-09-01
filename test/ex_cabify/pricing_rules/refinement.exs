defprotocol ExCabify.PricingRules.RefinementTest do
  use ExUnit.Case, async: true

  alias ExCabify.PricingRules.{Refinement, XForY, BulkPurchase}
  alias ExCabify.Storage.Product

  describe "XForY" do
    test "should refine products for XForY pricing rule" do
      pricing_rule = %XForY{applicable_count: 2, reduced_count: 1, applicable_code: "MUG"}

      products = [
        %Product{code: "MUG", price: 7.5},
        %Product{code: "MUG", price: 7.5},
        %Product{code: "MUG", price: 7.5}
      ]

      assert [
               %Product{code: "MUG", price: 3.75},
               %Product{code: "MUG", price: 3.75},
               %Product{code: "MUG", price: 7.5}
             ] = Refinement.run(pricing_rule, products)
    end
  end

  describe "BulkPurchase" do
    test "should refine products for BulkPurchase pricing rule" do
      pricing_rule = %BulkPurchase{
        applicable_count: 2,
        reduced_prize: 5.0,
        applicable_code: "MUG"
      }

      products = [
        %Product{code: "MUG", price: 7.5},
        %Product{code: "MUG", price: 7.5},
        %Product{code: "MUG", price: 7.5}
      ]

      assert [
               %Product{code: "MUG", price: 3.75},
               %Product{code: "MUG", price: 3.75},
               %Product{code: "MUG", price: 7.5}
             ] = Refinement.run(pricing_rule, products)
    end
  end
end
