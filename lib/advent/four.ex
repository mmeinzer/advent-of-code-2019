defmodule Advent.Four do
  def one do
    [first, last] = read_input()

    first..last
    |> Stream.filter(&is_increasing/1)
    |> Stream.filter(&has_double/1)
    |> Enum.count()
  end

  def two do
    [first, last] = read_input()

    first..last
    |> Stream.filter(&is_increasing/1)
    |> Stream.filter(&has_exact_double/1)
    |> Enum.count()
  end

  defp is_increasing(num) do
    digits = Integer.digits(num)
    digits == Enum.sort(digits)
  end

  defp has_double(num) do
    Integer.to_string(num)
    |> String.match?(~r/(\d)\1/)
  end

  defp has_exact_double(num) do
    Integer.to_string(num)
    |> String.match?(~r/((^)|(.))((?(3)(?!\1).|.))\4(?!\4)/)
  end

  defp read_input() do
    {:ok, bin} = File.read("./lib/inputs/four.txt")

    String.split(bin, ["-", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
