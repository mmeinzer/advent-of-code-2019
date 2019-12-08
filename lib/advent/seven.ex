defmodule Advent.Seven do
  def one do
    read_input()
    |> run(0)
  end

  def two do
    read_input()
  end

  def run(instructions, op_index) do
    get_op(instructions, op_index)
    # |> do_op(instructions)
  end

  def get_op(instructions, index) do
    Enum.fetch!(instructions, index)
    |> standardize_op()
    |> get_op_symbol()
  end

  def get_op_symbol({code, modes}) do
    case code do
      1 -> {:add, 4, modes |> zero_pad(2)}
      2 -> {:mul, 4, modes |> zero_pad(2)}
      3 -> {:inp, 2, modes |> zero_pad(0)}
      4 -> {:out, 2, modes |> zero_pad(1)}
      5 -> {:jit, 3, modes |> zero_pad(2)}
      6 -> {:jif, 3, modes |> zero_pad(2)}
      7 -> {:lt, 4, modes |> zero_pad(2)}
      8 -> {:eq, 4, modes |> zero_pad(2)}
      99 -> {:hlt, 1, modes |> zero_pad(0)}
    end
  end

  defp standardize_op(raw_op_code) do
    digits = Integer.digits(raw_op_code)
    length = digits |> length()

    cond do
      length <= 2 ->
        {raw_op_code, []}

      length >= 3 ->
        op_code = Enum.drop(digits, length - 2) |> Integer.undigits()
        modes = Enum.take(digits, length - 2) |> Enum.reverse()
        {op_code, modes}
    end
  end

  defp zero_pad(list, target_length) do
    cond do
      length(list) < target_length -> zero_pad(list ++ [0], target_length)
      true -> list
    end
  end

  defp read_input do
    {:ok, bin} = File.read("./lib/inputs/seven.txt")

    String.split(bin, [",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
