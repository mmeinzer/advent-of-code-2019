defmodule Advent.Three do
  def one do
    [wireA, wireB] = read_input()

    aDeltas = Enum.map(wireA, &parse_instruction/1)
    bDeltas = Enum.map(wireB, &parse_instruction/1)

    start = {0, 0}

    {_, aPositions} = Enum.reduce(aDeltas, {start, MapSet.new()}, &wire_reducer/2)
    {_, bPositions} = Enum.reduce(bDeltas, {start, MapSet.new()}, &wire_reducer/2)

    MapSet.intersection(aPositions, bPositions)
    |> MapSet.difference(MapSet.new([{0, 0}]))
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
  end

  defp wire_reducer(delta, acc) do
    {current_location, curr_positions} = acc

    {get_next_point(current_location, delta),
     get_points_between(current_location, delta)
     |> MapSet.union(curr_positions)}
  end

  defp put_point(point, points_set) do
    MapSet.put(points_set, point)
  end

  defp get_next_point(start, delta) do
    {x, y} = start
    {dx, dy} = delta

    {x + dx, y + dy}
  end

  defp get_points_between(start, delta) do
    {start_x, start_y} = start

    case delta do
      {dx, 0} ->
        Enum.reduce(0..dx, MapSet.new(), fn dx, acc -> put_point({start_x + dx, start_y}, acc) end)

      {0, dy} ->
        Enum.reduce(0..dy, MapSet.new(), fn dy, acc -> put_point({start_x, start_y + dy}, acc) end)
    end
  end

  defp parse_instruction(instruction) do
    {direction, distance_str} = String.split_at(instruction, 1)
    distance = String.to_integer(distance_str)

    case direction do
      "R" -> {distance, 0}
      "L" -> {-distance, 0}
      "U" -> {0, distance}
      "D" -> {0, -distance}
    end
  end

  defp read_input do
    {:ok, bin} = File.read("./lib/inputs/three.txt")

    String.split(bin, ["\n"], trim: true)
    |> Enum.map(fn wire ->
      String.split(wire, [","], trim: true)
    end)
  end
end
