defmodule SecEdgarTest do
  use ExUnit.Case
  doctest SecEdgar

  test "greets the world" do
    assert SecEdgar.hello() == :world
  end
end
