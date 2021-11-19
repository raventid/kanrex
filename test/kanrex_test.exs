defmodule KanrexTest do
  use ExUnit.Case
  use PropCheck

  doctest Kanrex

  # test "greets the world" do
  #   assert Kanrex.hello() == :world
  # end

  property "varialbe identifies correctly" do
    forall v <- var() do
      Kanrex.var?(v)
    end
  end

  property "variable unification" do
    forall {var1, var2} <- {var(), var()} do
      var1 == var2
    end
  end

  defp var() do
    term = :proper_types.term()
    sample = :proper_gen.pick(term)
    Kanrex.var(sample)
  end
end
