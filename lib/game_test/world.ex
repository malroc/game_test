defmodule GameTest.World do
  @map_width 8
  @map_height 8
  @range_x 0..(@map_width - 1)
  @range_y 0..(@map_height - 1)

  def map_width, do: @map_width
  def map_height, do: @map_height

  def generate_walls do
    [
      [false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false],
      [false, false, false, false, false, false, false, false],
      [true, false, true, true, true, true, false, false],
      [false, false, false, true, false, false, false, false],
      [false, false, false, true, false, false, false, false],
      [false, false, false, true, false, false, false, false],
      [false, false, false, false, false, false, false, false]
    ]
  end

  def wall_exists?(walls, x, y) when x in @range_x and y in @range_y do
    walls
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def wall_exists?(_walls, _x, _y), do: true

  def choose_free_cell(walls) do
    @range_x
    |> Enum.map(fn x ->
      Enum.map(@range_y, fn y ->
        unless wall_exists?(walls, x, y), do: {x, y}
      end)
    end)
    |> List.flatten()
    |> Enum.filter(& &1)
    |> Enum.random()
  end
end
