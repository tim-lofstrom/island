defmodule IslandsEngine.Game do
  use GenServer

  def handle_info(:first, state) do
    IO.puts("Matching on :first")
    {:noreply, state}
  end

  def handle_call(:demo_call, _from, state) do
    {:reply, state, state}
  end

end
