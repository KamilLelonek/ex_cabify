# ex_cabify

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

Firstly, you need to initialize a scanner.

You can do it without pricing rules:

    iex(1)> scanner = %ExCabify{}
    %ExCabify{basket: %ExCabify.Basket{products: []}, pricing_rules: nil}

with `Bulk` one:

    iex(2)> scanner = ExCabify.new(ExCabify.Discounts.Bulk)
    %ExCabify{
      basket: %ExCabify.Basket{products: []},
      pricing_rules: ExCabify.Discounts.Bulk
    }

or with `TwoForOne`:

    iex(3)> scanner = ExCabify.new(ExCabify.Discounts.TwoForOne)
    %ExCabify{
      basket: %ExCabify.Basket{products: []},
      pricing_rules: ExCabify.Discounts.TwoForOne
    }

Then, you are able to scan any product:

    iex(4)> {:ok, scanner} = ExCabify.scan(scanner, "VOUCHER")
    {:ok,
     %ExCabify{
       basket: %ExCabify.Basket{
         products: [
           %ExCabify.Storage.Product{
             code: "VOUCHER",
             name: "Cabify Voucher",
             price: 5.0
           }
         ]
       },
       pricing_rules: ExCabify.Discounts.Bulk
     }}
    iex(5)> {:ok, scanner} = ExCabify.scan(scanner, "TSHIRT")
    {:ok,
     %ExCabify{
       basket: %ExCabify.Basket{
         products: [
           %ExCabify.Storage.Product{
             code: "TSHIRT",
             name: "Cabify T-Shirt",
             price: 20.0
           },
           %ExCabify.Storage.Product{
             code: "VOUCHER",
             name: "Cabify Voucher",
             price: 5.0
           }
         ]
       },
       pricing_rules: ExCabify.Discounts.Bulk
     }}
    iex(6)> {:ok, scanner} = ExCabify.scan(scanner, "MUG")
    {:ok,
     %ExCabify{
       basket: %ExCabify.Basket{
         products: [
           %ExCabify.Storage.Product{
             code: "MUG",
             name: "Cafify Coffee Mug",
             price: 7.5
           },
           %ExCabify.Storage.Product{
             code: "TSHIRT",
             name: "Cabify T-Shirt",
             price: 20.0
           },
           %ExCabify.Storage.Product{
             code: "VOUCHER",
             name: "Cabify Voucher",
             price: 5.0
           }
         ]
       },
       pricing_rules: ExCabify.Discounts.Bulk
     }}

Finally, you can calculate the total price:

    iex(7)> ExCabify.total(scanner)
    32.5

## Testing

To run the test suite, execute:

    ➜  ex_cabify git:(master) ✗ mix test
    ..........................

    Finished in 0.1 seconds
    26 tests, 0 failures

    Randomized with seed 37474
