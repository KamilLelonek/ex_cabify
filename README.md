# ex_cabify

[![Build Status](https://travis-ci.org/KamilLelonek/ex_cabify.svg?branch=master)](https://travis-ci.org/KamilLelonek/ex_cabify)

##### Besides providing exceptional transportation services, Cabify also runs a physical store which sells (only) 3 products:

```
Code         | Name                |  Price
-------------------------------------------------
VOUCHER      | Cabify Voucher      |   5.00€
TSHIRT       | Cabify T-Shirt      |  20.00€
MUG          | Cafify Coffee Mug   |   7.50€
```

Various departments have insisted on the following discounts:

 * The marketing department believes in 2-for-1 promotions (buy two of the same product, get one free), and would like for there to be a 2-for-1 special on `VOUCHER` items.

 * The CFO insists that the best way to increase sales is with discounts on bulk purchases (buying x or more of a product, the price of that product is reduced), and demands that if you buy 3 or more `TSHIRT` items, the price per unit should be 19.00€.

Cabify's checkout process allows for items to be scanned in any order, and should return the total amount to be paid.

Examples:

    Items: VOUCHER, TSHIRT, MUG
    Total: 32.50€

    Items: VOUCHER, TSHIRT, VOUCHER
    Total: 25.00€

    Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
    Total: 81.00€

    Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
    Total: 74.50€

## Usage

Firstly, you need to initialize a **Checkout**.

You can do it without any **Pricing Rule**:

```elixir
iex(1)> checkout = ExCabify.Checkout.new()
%ExCabify.Checkout{codes: [], pricing_rules: []}
```

or with all of them:

```elixir
iex(2)> pricing_rules = ExCabify.PricingRules.all()
[
  %ExCabify.PricingRules.BulkPurchase{
    applicable_code: "TSHIRT",
    applicable_count: 3,
    reduced_prize: 19.0
  },
  %ExCabify.PricingRules.XForY{
    applicable_code: "VOUCHER",
    applicable_count: 2,
    reduced_count: 1
  }
]

iex(3)> checkout = ExCabify.Checkout.new(pricing_rules)
%ExCabify.Checkout{
  codes: [],
  pricing_rules: [
    %ExCabify.PricingRules.BulkPurchase{
      applicable_code: "TSHIRT",
      applicable_count: 3,
      reduced_prize: 19.0
    },
    %ExCabify.PricingRules.XForY{
      applicable_code: "VOUCHER",
      applicable_count: 2,
      reduced_count: 1
    }
  ]
}
```

You can define them in `priv/pricing_rules/` directory.

Then, you are able to scan any code:

```elixir
iex(4)> checkout = ExCabify.Checkout.scan(checkout, "TSHIRT")
%ExCabify.Checkout{
  codes: ["TSHIRT"],
  pricing_rules: [
    %ExCabify.PricingRules.BulkPurchase{
      applicable_code: "TSHIRT",
      applicable_count: 3,
      reduced_prize: 19.0
    },
    %ExCabify.PricingRules.XForY{
      applicable_code: "VOUCHER",
      applicable_count: 2,
      reduced_count: 1
    }
  ]
}

iex(5)> checkout = ExCabify.Checkout.scan(checkout, "TSHIRT")
%ExCabify.Checkout{
  codes: ["TSHIRT", "TSHIRT"],
  pricing_rules: [
    %ExCabify.PricingRules.BulkPurchase{
      applicable_code: "TSHIRT",
      applicable_count: 3,
      reduced_prize: 19.0
    },
    %ExCabify.PricingRules.XForY{
      applicable_code: "VOUCHER",
      applicable_count: 2,
      reduced_count: 1
    }
  ]
}

iex(6)> checkout = ExCabify.Checkout.scan(checkout, "MUG")
%ExCabify.Checkout{
  codes: ["MUG", "TSHIRT", "TSHIRT"],
  pricing_rules: [
    %ExCabify.PricingRules.BulkPurchase{
      applicable_code: "TSHIRT",
      applicable_count: 3,
      reduced_prize: 19.0
    },
    %ExCabify.PricingRules.XForY{
      applicable_code: "VOUCHER",
      applicable_count: 2,
      reduced_count: 1
    }
  ]
}
```

Finally, you can calculate the **Total Price**:

```elixir
iex(7)> ExCabify.Checkout.total(checkout)
32.5
```

## Testing

To run the test suite, execute:

    ➜  ex_cabify git:(master) ✗ mix test
    ..........................

    Finished in 0.1 seconds
    26 tests, 0 failures

    Randomized with seed 37474
