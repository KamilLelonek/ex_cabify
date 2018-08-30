defmodule ExCabify.Storage.ProductTest do
  use ExUnit.Case, async: true

  alias ExCabify.Storage.Product

  test "should update Product price" do
    new_price = 3.0
    product = %Product{price: 2.0}

    assert %Product{price: ^new_price} = Product.update_price(product, new_price)
  end
end
