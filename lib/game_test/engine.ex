defmodule GameTest.Engine do
  use GenServer, restart: :transient

  import Process, only: [send_after: 3]

  alias GameTest.{Player, World}

  @default_respawn_interval 5_000

  def start_link(options) do
    GenServer.start_link(__MODULE__, options[:respawn_interval] || @default_respawn_interval)
  end

  def init(respawn_interval) do
    send_after(self(), :respawn_players, respawn_interval)

    {:ok, %{players: %{}, respawn_interval: respawn_interval, walls: World.generate_walls()}}
  end

  def handle_call(:state, state), do: {:ok, state}

  def handle_cast(:create_player, state) do
    players = %{state.players | Player.new(state.players, state.walls)}

    {:noreply, %{state | players: players}}
  end

  def handle_cast({:maybe_create_player, player_name}, state) do
    players =
      case state.players[player_name] do
        nil ->
          %{state.players | Player.new(state.players, state.walls, player_name)}

        player ->
          state.players
      end

    {:noreply, %{state | players: players}}
  end

  def handle_cast({:attack_other_players, player_name}, state) do
    players =
      state.players
      |> Map.get(player_name)
      |> Player.attack(state.players)

    {:noreply, %{state | players: players}}
  end

  def handle_cast({:move_player, player_name, direction}, state) do
    player =
      state.players
      |> Map.get(player_name)
      |> Player.move(direction, state.walls)

    players =
      case player do
        nil ->
          state.players

        player ->
          %{state.players | player_name: player}
      end

    {:noreply, %{state | players: players}}
  end

  def handle_info(:respawn_players, state) do
    players =
      state.players
      |> Enum.reduce(state.players, fn {player_name, player}, players ->
        if player.is_alive do
          players
        else
          %{players | player_name => Player.respawn(player, state.walls)}
        end
      end)

    send_after(self(), :respawn_players, state.respawn_interval)

    {:noreply, %{state | players: players}}
  end
end
