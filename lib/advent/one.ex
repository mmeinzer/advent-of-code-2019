defmodule Advent.One do
  def one do
    read_input()
    |> Stream.map(&base_fuel_needed/1)
    |> Enum.sum()
  end

  def two do
    read_input()
    |> Stream.map(&all_fuel_needed/1)
    |> Enum.sum()
  end

  defp base_fuel_needed(weight) do
    max(Integer.floor_div(weight, 3) - 2, 0)
  end

  defp all_fuel_needed(weight, sum \\ 0) do
    additional_fuel = base_fuel_needed(weight)

    case additional_fuel do
      0 -> sum
      _ -> all_fuel_needed(additional_fuel, additional_fuel + sum)
    end
  end

  defp read_input do
    {:ok, bin} = File.read("./lib/inputs/one.txt")

    String.split(bin, "\n", trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end
end
