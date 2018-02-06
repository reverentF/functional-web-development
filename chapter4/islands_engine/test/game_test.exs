defmodule GameTest do
  use ExUnit.Case
  doctest IslandsEngine
  alias IslandsEngine.{Board, Coordinate, Guesses, Game, Island, Rules}

  """
    Chapter 4 GenServer
  """
  test "update player name" do
    {:ok, game} = Game.start_link("Frank")
    Game.add_player(game, "Dweezil")
    state_data = :sys.get_state(game)
    assert state_data.player1.name == "Frank"
    assert state_data.player2.name == "Dweezil"
  end

  test "position island" do
    {:ok, game} = Game.start_link("Fred")
    Game.add_player(game, "Wilma")
    state_data = :sys.get_state(game)
    assert state_data.rules.state == :players_set
    Game.position_island(game, :player1, :square, 1, 1)
    state_data = :sys.get_state(game)    
    assert state_data.player1.board.square.coordinates != nil
  end
end
