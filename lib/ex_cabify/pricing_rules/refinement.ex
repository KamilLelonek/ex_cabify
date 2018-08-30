defprotocol ExCabify.PricingRules.Refinement do
  def run(pricing_rule, products)
end
