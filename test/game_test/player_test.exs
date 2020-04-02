defmodule GameTest.PlayerTest do
  use ExUnit.Case

  alias GameTest.Player

  test "move", _data do
    walls = [[false, true], [false, false]]
    player = %Player{name: "test", x: 0, y: 0}

    assert Player.move(player, :right, walls) == player
    assert Player.move(player, :up, walls) == player
    assert Player.move(player, :left, walls) == player
    assert Player.move(player, :down, walls) == %Player{player | y: 1}
    assert Player.move(%Player{player | is_alive: false}, :down, walls) == %Player{player | is_alive: false}
  end

  test "attack", _data do
    {player_1, player_2} =
      {%Player{name: "test1", x: 0, y: 0, is_alive: true},
       %Player{name: "test2", x: 0, y: 0, is_alive: true}}

    assert Player.attack(player_1, %{"test1" => player_1, "test2" => player_2}) == %{
             "test1" => player_1,
             "test2" => %Player{player_2 | is_alive: false}
           }

    {player_1, player_2} =
      {%Player{name: "test1", x: 0, y: 0, is_alive: true},
       %Player{name: "test2", x: 1, y: 0, is_alive: true}}

    assert Player.attack(player_1, %{"test1" => player_1, "test2" => player_2}) == %{
             "test1" => player_1,
             "test2" => %Player{player_2 | is_alive: false}
           }

    {player_1, player_2} =
      {%Player{name: "test1", x: 0, y: 0, is_alive: true},
       %Player{name: "test2", x: 0, y: 1, is_alive: true}}

    assert Player.attack(player_1, %{"test1" => player_1, "test2" => player_2}) == %{
             "test1" => player_1,
             "test2" => %Player{player_2 | is_alive: false}
           }

    {player_1, player_2} =
      {%Player{name: "test1", x: 0, y: 0, is_alive: true},
       %Player{name: "test2", x: 1, y: 1, is_alive: true}}

    assert Player.attack(player_1, %{"test1" => player_1, "test2" => player_2}) == %{
             "test1" => player_1,
             "test2" => %Player{player_2 | is_alive: false}
           }

    {player_1, player_2} =
      {%Player{name: "test1", x: 0, y: 0, is_alive: true},
       %Player{name: "test2", x: 2, y: 1, is_alive: true}}

    assert Player.attack(player_1, %{"test1" => player_1, "test2" => player_2}) == %{
             "test1" => player_1,
             "test2" => player_2
           }

    {player_1, player_2} =
      {%Player{name: "test1", x: 0, y: 0, is_alive: false},
       %Player{name: "test2", x: 0, y: 0, is_alive: true}}

    assert Player.attack(player_1, %{"test1" => player_1, "test2" => player_2}) == %{
             "test1" => player_1,
             "test2" => player_2
           }
  end
end
