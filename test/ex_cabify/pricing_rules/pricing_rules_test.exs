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
end
