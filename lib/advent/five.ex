defmodule Advent.Five do
  def one do
    read_input()
    |> execute(0)
  end

  def two do
    read_input()
    |> execute(0)
  end

  def execute(instructions, op_index) do
    get_op(instructions, op_index)
    |> do_op(instructions, op_index)
  end

  def set_memory(instructions, index, value) do
    List.replace_at(instructions, index, value)
  end

  def get_memory(instructions, index) do
    Enum.fetch!(instructions, index)
  end

  def next_op_index(current_op_index, distance), do: current_op_index + distance

  def get_op(instructions, index) do
    op_as_list =
      get_memory(instructions, index)
      |> Integer.digits()
      |> Enum.reverse()

    case op_as_list do
      [1] -> {:add, 4, []}
      [2] -> {:multiply, 4, []}
      [3] -> {:input, 2}
      [4] -> {:output, 2}
      [5] -> {:jmp_if_true, 3, [0]}
      [6] -> {:jmp_if_false, 3, [0]}
      [7] -> {:less_than, 4, [0]}
      [8] -> {:equals, 4, [0]}
      [9, 9] -> {:halt}
      [1, 0 | modes] -> {:add, 4, modes}
      [2, 0 | modes] -> {:multiply, 4, modes}
      [4, 0 | modes] -> {:output, 2, modes}
      [5, 0 | modes] -> {:jmp_if_true, 3, modes}
      [6, 0 | modes] -> {:jmp_if_false, 3, modes}
      [7, 0 | modes] -> {:less_than, 4, modes}
      [8, 0 | modes] -> {:equals, 4, modes}
    end
  end

  def do_op({:halt}, instructions, _op_index), do: instructions

  def do_op({:input, next_op_distance}, instructions, op_index) do
    input_int =
      IO.gets("Input: ")
      |> String.split("\n", trim: true)
      |> Enum.join()
      |> String.to_integer()

    destination_address = Enum.fetch!(instructions, op_index + 1)
    next_op = next_op_index(op_index, next_op_distance)

    set_memory(instructions, destination_address, input_int)
    |> execute(next_op)
  end

  def do_op({:output, next_op_distance}, instructions, op_index) do
    output_address = get_memory(instructions, op_index + 1)
    value = get_memory(instructions, output_address)
    IO.puts("Output: " <> Integer.to_string(value))

    next_op = next_op_index(op_index, next_op_distance)
    execute(instructions, next_op)
  end

  def do_op({:output, next_op_distance, modes}, instructions, op_index) do
    a = get_memory(instructions, op_index + 1)
    next_op = next_op_index(op_index, next_op_distance)

    case modes do
      [0] ->
        value = get_memory(instructions, a)
        IO.puts("Output: " <> Integer.to_string(value))
        execute(instructions, next_op)

      [1] ->
        IO.puts("Output: " <> Integer.to_string(a))
        execute(instructions, next_op)
    end
  end

  def do_op({:jmp_if_true, next_op_distance, modes}, instructions, op_index) do
    a = get_memory(instructions, op_index + 1)
    val_a = get_memory(instructions, a)

    b = get_memory(instructions, op_index + 2)

    case {a, val_a, modes} do
      {_, 0, []} ->
        execute(instructions, next_op_index(op_index, next_op_distance))

      {_, 0, [0 | _]} ->
        execute(instructions, next_op_index(op_index, next_op_distance))

      {0, _, [1 | _]} ->
        execute(instructions, next_op_index(op_index, next_op_distance))

      {_, _, [1, 1]} ->
        execute(instructions, b)

      {_, _, [0, 1]} ->
        execute(instructions, b)

      {_, _, [1]} ->
        val_b = get_memory(instructions, b)
        execute(instructions, val_b)
    end
  end

  def do_op({:jmp_if_false, next_op_distance, modes}, instructions, op_index) do
    a = get_memory(instructions, op_index + 1)
    val_a = get_memory(instructions, a)

    b = get_memory(instructions, op_index + 2)

    case {a, val_a, modes} do
      {0, _, [1, 1]} ->
        execute(instructions, b)

      {0, _, [1]} ->
        val_b = get_memory(instructions, b)
        execute(instructions, val_b)

      {_, 0, []} ->
        val_b = get_memory(instructions, b)
        execute(instructions, val_b)

      {_, 0, [0, 1]} ->
        execute(instructions, b)

      _ ->
        execute(instructions, next_op_index(op_index, next_op_distance))
    end
  end

  def do_op({:less_than, next_op_distance, modes}, instructions, op_index) do
    a = get_memory(instructions, op_index + 1)
    b = get_memory(instructions, op_index + 2)
    val_a = get_memory(instructions, a)
    val_b = get_memory(instructions, b)
    dest_addr = get_memory(instructions, op_index + 3)

    case modes do
      [] ->
        cond do
          val_a < val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [0] ->
        cond do
          val_a < val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [1] ->
        cond do
          a < val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [1, 0] ->
        cond do
          a < val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [0, 1] ->
        cond do
          val_a < b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [1, 1] ->
        cond do
          a < b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end
    end
  end

  def do_op({:equals, next_op_distance, modes}, instructions, op_index) do
    a = get_memory(instructions, op_index + 1)
    b = get_memory(instructions, op_index + 2)
    val_a = get_memory(instructions, a)
    val_b = get_memory(instructions, b)
    dest_addr = get_memory(instructions, op_index + 3)

    case modes do
      [] ->
        cond do
          val_a == val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [0] ->
        cond do
          val_a == val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [1] ->
        cond do
          a == val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [1, 0] ->
        cond do
          a == val_b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [0, 1] ->
        cond do
          val_a == b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end

      [1, 1] ->
        cond do
          a == b ->
            set_memory(instructions, dest_addr, 1)
            |> execute(next_op_index(op_index, next_op_distance))

          true ->
            set_memory(instructions, dest_addr, 0)
            |> execute(next_op_index(op_index, next_op_distance))
        end
    end
  end

  def do_op({:add, next_op_distance, modes}, instructions, op_index) do
    a = get_memory(instructions, op_index + 1)
    b = get_memory(instructions, op_index + 2)
    dest_addr = get_memory(instructions, op_index + 3)

    next_op = next_op_index(op_index, next_op_distance)

    case modes do
      [] ->
        val_a = get_memory(instructions, a)
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, val_a + val_b)
        |> execute(next_op)

      [1] ->
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, a + val_b)
        |> execute(next_op)

      [1, 0] ->
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, a + val_b)
        |> execute(next_op)

      [0] ->
        val_a = get_memory(instructions, a)
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, val_a + val_b)
        |> execute(next_op)

      [0, 1] ->
        val_a = get_memory(instructions, a)

        set_memory(instructions, dest_addr, val_a + b)
        |> execute(next_op)

      [1, 1] ->
        set_memory(instructions, dest_addr, a + b)
        |> execute(next_op)
    end
  end

  def do_op({:multiply, next_op_distance, modes}, instructions, op_index) do
    a = get_memory(instructions, op_index + 1)
    b = get_memory(instructions, op_index + 2)
    dest_addr = get_memory(instructions, op_index + 3)

    next_op = next_op_index(op_index, next_op_distance)

    case modes do
      [] ->
        val_a = get_memory(instructions, a)
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, val_a * val_b)
        |> execute(next_op)

      [1] ->
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, a * val_b)
        |> execute(next_op)

      [1, 0] ->
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, a * val_b)
        |> execute(next_op)

      [0] ->
        val_a = get_memory(instructions, a)
        val_b = get_memory(instructions, b)

        set_memory(instructions, dest_addr, val_a * val_b)
        |> execute(next_op)

      [0, 1] ->
        val_a = get_memory(instructions, a)

        set_memory(instructions, dest_addr, val_a * b)
        |> execute(next_op)

      [1, 1] ->
        set_memory(instructions, dest_addr, a * b)
        |> execute(next_op)
    end
  end

  def read_input do
    {:ok, bin} = File.read("./lib/inputs/five.txt")

    String.split(bin, [",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
