defmodule AdHocTest do
  use ExUnit.Case
  use PropCheck

  doctest Kanrex

  test "display closure" do
    f = Kanrex.call_fresh(
      fn(q) -> Kanrex.unify(q, 5, Map.new()) end
    )

    assert %{%Kanrex.Var{id: 0} => 5} == f.(Kanrex.empty_state())
  end
end
