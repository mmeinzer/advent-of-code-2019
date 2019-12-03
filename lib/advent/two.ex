defmodule Advent.Two do
  @goal_value 19690720

  def one do
    read_input()
    |> set_memory(1, 12)
    |> set_memory(2, 2)
    |> execute(0)
  end

  def two do
    read_input()
  end

  defp execute(instructions, op_index) do
    get_op(instructions, op_index)
    |> do_op(instructions, op_index)
  end

  defp set_memory(instructions, index, value) do
    List.replace_at(instructions, index, value)
  end

  defp next_op_index(current_op_index), do: current_op_index + 4

  defp get_op(instructions, index) do
    case Enum.fetch!(instructions, index) do
      1 -> :add
      2 -> :mul
      99 -> nil
    end
  end

  defp do_op(op, instructions, _op_index) when is_nil(op), do: instructions

  defp do_op(op, instructions, op_index) do
    register_a = Enum.fetch!(instructions, op_index + 1)
    value_a = Enum.fetch!(instructions, register_a)

    register_b = Enum.fetch!(instructions, op_index + 2)
    value_b = Enum.fetch!(instructions, register_b)

    destination = Enum.fetch!(instructions, op_index + 3)

    case op do
      :add ->
        execute(
          List.replace_at(instructions, destination, value_a + value_b),
          next_op_index(op_index)
        )

      :mul ->
        execute(
          List.replace_at(instructions, destination, value_a * value_b),
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
