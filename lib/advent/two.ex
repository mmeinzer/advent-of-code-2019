defmodule Advent.Two do
  def one do
    read_input()
    |> execute()
  end

  defp execute(instructions, op_index \\ 0) do
    get_op(instructions, op_index)
    |> do_op(instructions, op_index)
  end

  defp next_op_index(current_op_index), do: current_op_index + 4

  defp get_op(instructions, index) do
    op_code = Enum.at(instructions, index)

    case op_code do
      1 -> :add
      2 -> :mul
      99 -> nil
    end
  end

  defp do_op(op, instructions, _op_index) when is_nil(op), do: instructions

  defp do_op(op, instructions, op_index) do
    register_a = Enum.at(instructions, op_index + 1)
    register_b = Enum.at(instructions, op_index + 2)
    destination = Enum.at(instructions, op_index + 3)

    case op do
      :add ->
        execute(
          List.replace_at(instructions, destination, register_a + register_b),
          next_op_index(op_index)
        )

      :mul ->
        execute(
          List.replace_at(instructions, destination, register_a * register_b),
          next_op_index(op_index)
        )
    end
  end

  defp read_input do
    {:ok, bin} = File.read("./lib/inputs/two.txt")

    String.split(bin, [",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
