defmodule Kanrex do
  @moduledoc """
  Documentation for `Kanrex`.

  Reference implementation - http://webyrd.net/scheme-2013/papers/HemannMuKanren2013.pdf
  """

  @doc """
  Hello world.

  ## Examples

      iex> Kanrex.hello()
      :world

  """
  defmodule Var do
    defstruct id: nil
  end

  def var(id) do
    %Var{id: id}
  end

  def var? x do
    case x do
      %Var{} -> true
      _ -> false
    end
  end

  # u - term
  # s - substitution
  def walk(u, s) do
    case u do
      %Var{} ->
        found = Map.get(s, u)
        if found do
          walk(found, s)
        else
          u
        end
      _ -> u
    end
  end

  # u - Term
  # v - Term
  # s - Substitution
  def unify(u, v, s) do
    u = walk(u, s)
    v = walk(v, s)
    case {u, v} do
      {%Var{id: id}, %Var{id: id}} -> s
      {%Var{}, _} -> Map.put(s, u, v)
      {_, %Var{}} -> Map.put(s, v, u)
      {[u_car|u_cdr], [v_car|v_cdr]} ->
        s = unify(u_car, v_car, s)
        s && unify(u_cdr, v_cdr, s)
      _ -> u === v && s
    end
  end
end
