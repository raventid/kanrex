defmodule KanrexTest do
  use ExUnit.Case
  use PropCheck

  doctest Kanrex

  test "greets the world" do
    assert Kanrex.hello() == :world
  end

  property "always works" do
    forall type <- term() do
      boolean(type)
    end
  end

  def boolean(_) do
    true
  end
end
