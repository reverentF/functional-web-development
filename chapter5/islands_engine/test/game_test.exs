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

  test "set island" do
    {:ok, game} = Game.start_link("Dino")
    Game.add_player(game, "Pebbles")
    assert Game.position_island(game, :player1, :atoll, 1, 1) == :ok
    assert Game.position_island(game, :player1, :dot, 1, 4) == :ok
    assert Game.position_island(game, :player1, :l_shape, 1, 5) == :ok
    assert Game.position_island(game, :player1, :s_shape, 5, 1) == :ok
    assert Game.position_island(game, :player1, :square, 5, 5) == :ok

    {:ok, board} = Game.set_islands(game, :player1)

    state_data = :sys.get_state(game)
    assert state_data.rules.player1 == :islands_set
    assert state_data.rules.state == :players_set
  end

  test "set island both player" do
    {:ok, game} = Game.start_link("Dino")
    Game.add_player(game, "Pebbles")
    assert Game.position_island(game, :player1, :atoll, 1, 1) == :ok
    assert Game.position_island(game, :player1, :dot, 1, 4) == :ok
    assert Game.position_island(game, :player1, :l_shape, 1, 5) == :ok
    assert Game.position_island(game, :player1, :s_shape, 5, 1) == :ok
    assert Game.position_island(game, :player1, :square, 5, 5) == :ok
    {:ok, board} = Game.set_islands(game, :player1)

    assert Game.position_island(game, :player2, :atoll, 1, 1) == :ok
    assert Game.position_island(game, :player2, :dot, 1, 4) == :ok
    assert Game.position_island(game, :player2, :l_shape, 1, 5) == :ok
    assert Game.position_island(game, :player2, :s_shape, 5, 1) == :ok
    assert Game.position_island(game, :player2, :square, 5, 5) == :ok
    {:ok, board} = Game.set_islands(game, :player2)

    state_data = :sys.get_state(game)
    assert state_data.rules.player1 == :islands_set
    assert state_data.rules.player2 == :islands_set    
    assert state_data.rules.state == :player1_turn
  end

  test "guesses check" do
    {:ok, game} = Game.start_link("Miles")
    assert Game.guess_coordinate(game, :player1, 1, 1) == :error

    Game.add_player(game, "Trane")
    assert Game.position_island(game, :player1, :dot, 1, 1) == :ok
    assert Game.position_island(game, :player2, :square, 1, 1) == :ok
    # short cut
    state_data = :sys.get_state(game)
    state_data = :sys.replace_state(game, fn data ->
      %{state_data | rules: %Rules{state: :player1_turn}}
    end)
    assert state_data.rules.state == :player1_turn

    # guess no islands coordinate
    assert {:miss, :none, :no_win} == Game.guess_coordinate(game, :player1, 5, 5)
    # guess invalid player
    assert :error == Game.guess_coordinate(game, :player1, 3, 1)
    # guess islands coordinate
    assert {:hit, :dot, :win} == Game.guess_coordinate(game, :player2, 1, 1)
  end

  test "process name" do
    via = Game.via_tuple("Lena")
    GenServer.start_link(Game, "Lena", name: via)
    assert :sys.get_state(via) != :error
    {:error, _} = GenServer.start_link(Game, "Lena", name: via)
  end
end
