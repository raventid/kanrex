defmodule KanrexTest do
  use ExUnit.Case
  doctest Kanrex

  test "greets the world" do
    assert Kanrex.hello() == :world
  end
end
