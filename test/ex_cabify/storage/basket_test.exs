defmodule ExCabify.Storage.BasketTest do
  use ExUnit.Case, async: true

  alias ExCabify.Storage.{Basket, Product}

  test "should have no Products after creating" do
    assert %Basket{products: []} = Basket.new()
  end

  test "should add new Products to a Basket" do
    product_1 = %Product{name: "a"}
    product_2 = %Product{name: "b"}
    basket = Basket.new()

    basket = Basket.put(basket, product_1)

    assert %Basket{products: [^product_1]} = basket
    assert %Basket{products: [^product_2, ^product_1]} = Basket.put(basket, product_2)
  end
end
