defmodule Kanrex do
  @moduledoc """
  Documentation for `Kanrex`.

  Reference implementation - http://webyrd.net/scheme-2013/papers/HemannMuKanren2013.pdf
  """

  @doc """
  Kanrex reference.


  ## Create var

      iex> Kanrex.var(true)
      %Kanrex.Var{id: true}

  """

  # Variable representation
  defmodule Var do
    defstruct id: nil
  end

  # State representation
  defmodule State do
    defstruct id_counter: 0, substitution: %{}
  end

  def create_state(c, s) do
    %State{id_counter: c, substitution: s}
  end

  def empty_state do
    %State{}
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

  # u - term
  # v - term
  # s - substitution
  def unify(u, v, s) do
    u = walk(u, s)
    v = walk(v, s)
    case {u, v} do
      {%Var{id: id}, %Var{id: id}} -> s
      {%Var{}, _} -> Map.put(s, u, v)
      {_, %Var{}} -> Map.put(s, v, u)
      {[u_car | u_cdr], [v_car | v_cdr]} ->
        s = unify(u_car, v_car, s)
        s && unify(u_cdr, v_cdr, s)
      _ -> u === v && s
    end
  end

  # u - term
  # v - term
  def eqo(u, v) do
    fn state ->
      s = unify(u, v, Map.get(state, :substitution))
      if s do
        [%State{state | substitution: s}]
      else
        []
      end
    end
  end

  # fun - (var -> goal)
  def call_with_fresh(fun) do
    fn state ->
      id = Map.get(state, :id_counter)
      goal = fun.(var(id))
      goal.(%State{state | id_counter: id + 1})
    end
  end
end
