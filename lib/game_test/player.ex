defmodule GameTest.Player do
  defstruct [:name, :x, :y, status: :alive]

  @name_parts {[:scared, :scary, :critical, :strong], [:hero, :pickle, :gangsta, :cactus]}

  alias GameTest.World

  def new(players, walls, name \\ nil) do
    %__MODULE__{}
    |> assign_free_cell(walls)
    |> assign_name(name, players)
  end

  def respawn(player, walls) do
    player
    |> assign_free_cell(walls)
    |> Map.put(:status, :alive)
  end

  def attack(%__MODULE__{status: :dead}, players), do: players
  def attack(%__MODULE__{status: :respawning}, players), do: players

  def attack(%__MODULE__{} = player, players) do
    dead_players =
      players
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.reject(&self?(&1, player))
      |> Enum.filter(&near?(&1, player))
      |> Enum.map(&{&1.name, %__MODULE__{&1 | status: :dead}})
      |> Map.new()

    Map.merge(players, dead_players)
  end

  def attack(_player, players), do: players

  def move(%__MODULE__{status: :dead} = player, _direction, _walls), do: player
  def move(%__MODULE__{status: :respawning} = player, _direction, _walls), do: player

  def move(%__MODULE__{} = player, :left, walls), do: move(player, {-1, 0}, walls)
  def move(%__MODULE__{} = player, :right, walls), do: move(player, {1, 0}, walls)
  def move(%__MODULE__{} = player, :up, walls), do: move(player, {0, -1}, walls)
  def move(%__MODULE__{} = player, :down, walls), do: move(player, {0, 1}, walls)

  def move(%__MODULE__{} = player, {delta_x, delta_y}, walls) do
    if World.wall_exists?(walls, player.x + delta_x, player.y + delta_y) do
      player
    else
      %__MODULE__{player | x: player.x + delta_x, y: player.y + delta_y}
    end
  end

  def move(_player, _direction, _walls), do: nil

  def self?(player1, player2), do: player1.name == player2.name

  def near?(player1, player2) do
    player1.x in (player2.x - 1)..(player2.x + 1) && player1.y in (player2.y - 1)..(player2.y + 1)
  end

  defp assign_free_cell(%__MODULE__{} = player, walls) do
    {x, y} = World.choose_free_cell(walls)

    %__MODULE__{player | x: x, y: y}
  end

  defp assign_name(%__MODULE__{} = player, name, players) do
    %__MODULE__{player | name: name || choose_name(players)}
  end

  defp choose_name(players) do
    {left_parts, right_parts} = @name_parts

    "#{Enum.random(left_parts)} #{Enum.random(right_parts)}"
    |> append_name_suffix(players)
  end

  defp append_name_suffix(name, players, number \\ 0) do
    current_name = if number == 0, do: name, else: "#{name} #{number}"

    case players[current_name] do
      nil ->
        current_name

      _ ->
        append_name_suffix(name, players, number + 1)
    end
  end
end
