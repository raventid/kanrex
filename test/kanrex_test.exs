defmodule KanrexTest do
  use ExUnit.Case
  use PropCheck

  doctest Kanrex

  property "only Kanrex.var is a variable" do
    forall {v, t} <- {var(), term()} do
      Kanrex.var?(v) && !Kanrex.var?(t)
    end
  end

  property "walk to the value" do
    forall {k, v, map} <- map_contains_var() do
      v == Kanrex.walk(k, map)
    end
  end

  test "unify two vars" do
     s = Map.new()
     u = Kanrex.var(true)
     v = Kanrex.var(true)
     assert Kanrex.unify(u,v,s) == s
  end

  test "unify first var" do
     s = Map.new()
     u = Kanrex.var(true)
     v = true
     assert Kanrex.unify(u,v,s) == %{u => v}
  end

  test "unify second var" do
     s = Map.new()
     u = true
     v = Kanrex.var(true)
     assert Kanrex.unify(u,v,s) == %{v => u}
  end

  test "unify two lists" do
     s = Map.new()
     u = [true, true]
     v = [Kanrex.var(true), Kanrex.var(true)]
     assert Kanrex.unify(u,v,s) == %{%Kanrex.Var{id: true} => true}
  end

  test "unify no match without equality" do
     s = Map.new()
     u = true
     v = false
     assert Kanrex.unify(u, v, s) == false
  end

  test "unify no match with equality" do
     s = Map.new()
     u = true
     v = true
     assert Kanrex.unify(u, v, s) == Map.new
  end

  defp var() do
    term = :proper_types.term()
    sample = :proper_gen.pick(term)
    Kanrex.var(sample)
  end

  defp map_contains_var() do
    r = Enum.random(2..8)

    {k,v} = if 1 === Enum.random(1..5) do
      { [], [] }
    else
      { Kanrex.var(r-1), Kanrex.var(r+1) }
    end

    map = 1..r
    |> Enum.reduce(
      Map.new(),
      fn (val, acc) ->
        Map.put(acc, Kanrex.var(val), Kanrex.var(val+1))
      end)

    {k, v, map}
  end

    # defp var_or_term() do
  #   oneof([var(), term()])
  # end
end
