defmodule ExCabify.BasketTest do
  use ExUnit.Case, async: true

  alias ExCabify.{Basket, Storage.Product}

  test "should have no Products after creating" do
    assert %Basket{products: []} = Basket.new()
  end

  test "should have an amount of 0 for an empty Basket" do
    basket = %Basket{}

    assert 0 = Basket.amount(basket)
  end

  test "should add new Products to a Basket" do
    product_1 = %Product{name: "a"}
    product_2 = %Product{name: "b"}
    basket = Basket.new()

    basket = Basket.put(basket, product_1)

    assert %Basket{products: [^product_1]} = basket
    assert %Basket{products: [^product_2, ^product_1]} = Basket.put(basket, product_2)
  end

  test "should calculate Basket amount" do
    price_1 = 10
    price_2 = 20
    product_1 = %Product{price: price_1}
    product_2 = %Product{price: price_2}
    basket = %Basket{}

    basket = Basket.put(basket, product_1)
    basket = Basket.put(basket, product_2)

    assert price_1 + price_2 == Basket.amount(basket)
  end
end
