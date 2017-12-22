defmodule IslandsEngineTest do
  use ExUnit.Case
  doctest IslandsEngine
  alias IslandsEngine.Rules

  test "greets the world" do
    assert IslandsEngine.hello() == :world
  end

  """
    Chapter 3 Sate Machine
  """
  test "initialize state machine" do
    rules = Rules.new()
    assert rules.state == :initialized
    assert rules.player1 == :islands_not_set
    assert rules.player2 == :islands_not_set
  end

  test "state :initialize -> :players_set with :add_player" do
    rules = Rules.new()
    {:ok, rules} = Rules.check(rules, :add_player)
    assert rules.state == :players_set
  end

  test "state :initialize -x> :players_set with :hoge" do
    rules = Rules.new()
    :error = Rules.check(rules, :hoge)
    assert rules.state == :initialized
  end

  test "state :players_set" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
    assert rules.player1 == :islands_set
    assert rules.player2 == :islands_not_set
    assert rules.state == :players_set
  end

  test "state :players_set -< :player1_turn when both players placed" do
    rules = Rules.new()
    rules = %{rules | state: :players_set}
    {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})    
    assert rules.player1 == :islands_set
    assert rules.player2 == :islands_set
    assert rules.state == :player1_turn
  end

  test "switch players turn" do
    rules = Rules.new()
    rules = %{rules | state: :player1_turn}
    :error = Rules.check(rules, {:guess_codinate, :player2})
    {:ok, rules} = Rules.check(rules, {:guess_codinate, :player1})    
    assert rules.state == :player2_turn
    :error = Rules.check(rules, {:guess_codinate, :player1})
    {:ok, rules} = Rules.check(rules, {:guess_codinate, :player2})    
    assert rules.state == :player1_turn
  end

  test "win_check" do
    rules = Rules.new()
    rules = %{rules | state: :player1_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state == :player1_turn
    {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state == :game_over
    
    rules = Rules.new()
    rules = %{rules | state: :player2_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state == :player2_turn
    {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state == :game_over
  end

end
