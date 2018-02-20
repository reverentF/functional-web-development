defmodule SupervisorTest do
  use ExUnit.Case
  doctest IslandsEngine
  alias IslandsEngine.{Game, GameSupervisor}

  """
    Chapter 5
  """

  test "start game" do
    {:ok, game} = GameSupervisor.start_game("Cassatt")
    via = Game.via_tuple("Cassatt")
    count = Supervisor.count_children(GameSupervisor)
    
    assert count.active == 1
    assert count.specs == 1
    assert count.supervisors == 0
    assert count.workers == 1
  end

  test "stop game" do
    {:ok, game} = GameSupervisor.start_game("Hoge")
    via = Game.via_tuple("Hoge")
    assert GameSupervisor.stop_game("Hoge") == :ok
    assert Process.alive?(game) == false
    assert GenServer.whereis(via) == nil
  end

  test "saved state when game restarts" do
    {:ok, game} = GameSupervisor.start_game("AAA")
    via = Game.via_tuple("AAA")
    Game.add_player(game, "BBB")
    Process.exit(game, :kaboom)
    state_data = :sys.get_state(via)
    assert state_data.player1.name == "AAA"
    assert state_data.player2.name == "BBB"    
  end

  test "delete state from ETS when game stopped" do
    {:ok, game} = GameSupervisor.start_game("12345")
    via = Game.via_tuple("12345")
    Game.add_player(game, "67890")
    GameSupervisor.stop_game("12345")
    assert Process.alive?(game) == false
    assert GenServer.whereis(via) == nil
    assert :ets.lookup(:game_state, "12345") == []
  end
end
