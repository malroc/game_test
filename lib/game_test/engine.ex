defmodule GameTest.Engine do
  use GenServer, restart: :transient

  import Process, only: [send_after: 3]

  alias GameTest.{Player, World}

  @default_respawn_interval 5_000

  def start_link(options) do
    GenServer.start_link(__MODULE__, options[:respawn_interval] || @default_respawn_interval,
      name: __MODULE__
    )
  end

  def init(respawn_interval) do
    send_after(self(), :respawn_players, respawn_interval)

    {:ok, %{players: %{}, respawn_interval: respawn_interval, walls: World.generate_walls()}}
  end

  def handle_call(:state, _from, state), do: {:reply, state, state}

  def handle_call(:create_player, _from, state) do
    player = Player.new(state.players, state.walls)
    players = Map.put(state.players, player.name, player)

    {:reply, player, %{state | players: players}}
  end

  def handle_call({:maybe_create_player, player_name}, _from, state) do
    {player, players} =
      case state.players[player_name] do
        nil ->
          player = Player.new(state.players, state.walls, player_name)
          {player, Map.put(state.players, player_name, player)}

        player ->
          {player, state.players}
      end

    {:reply, player, %{state | players: players}}
  end

  def handle_call({:attack_other_players, player_name}, _from, state) do
    player = Map.get(state.players, player_name)
    players = Player.attack(player, state.players)

    {:reply, player, %{state | players: players}}
  end

  def handle_call({:move_player, player_name, direction}, _from, state) do
    player =
      state.players
      |> Map.get(player_name)
      |> Player.move(direction, state.walls)

    players =
      case player do
        nil ->
          state.players

        player ->
          %{state.players | player_name => player}
      end

    {:reply, player, %{state | players: players}}
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
