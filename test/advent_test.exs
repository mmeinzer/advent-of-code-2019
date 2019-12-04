defmodule AdventTest do
  use ExUnit.Case
  doctest Advent
  doctest Advent.Three

  test "greets the world" do
    assert Advent.hello() == :world
  end
end
