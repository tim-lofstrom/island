defmodule IslandsEngine.Board do

  alias IslandsEngine.{Coordinate, Island}

  def new(), do: %{}

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> Map.put(board, key, island)
    end
  end

  def overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  def all_islands_positioned?(board) do
    Enum.all?(Island.types, &(Map.has_key?(board, &1)))
  end

  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  def check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  def guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forrest_check(board, key), win_check(board), board}
  end

  def guess_response(:miss, board) do
    {:miss, :none, :no_win, board}
  end

  def forrest_check(board, key) do
    case forrested?(board, key) do
      true -> key
      false -> :none
    end
  end

  def forrested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  def win_check(board) do
    case all_forrested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  def all_forrested?(board) do
    Enum.all?(board, fn {_key, island} ->
      Island.forested?(island)
    end)
  end

end
