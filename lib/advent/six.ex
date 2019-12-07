defmodule Advent.Six do
  def one do
    read_input()
  end

  defp read_input do
    {:ok, bin} = File.read("./lib/inputs/six.txt")

    String.split(bin, "\n", trim: true)
    |> Enum.map(fn orbit_string -> String.split(orbit_string, ")", trim: true) end)
  end
end
