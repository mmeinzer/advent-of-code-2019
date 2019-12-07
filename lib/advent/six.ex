defmodule Advent.Six do
  def one do
    one_to_one =
      read_input()
      |> Enum.reduce(%{}, &map_orbits/2)

    Enum.reduce(one_to_one, %{}, fn {body, _}, acc ->
      Map.put(acc, body, length(get_orbit_chain(one_to_one, body)))
    end)
    |> Enum.reduce(0, fn {_, orbits}, sum -> sum + orbits end)
  end

  def two do
    one_to_one =
      read_input()
      |> Enum.reduce(%{}, &map_orbits/2)

    santas_planet = Map.get(one_to_one, "SAN")
    my_planet = Map.get(one_to_one, "YOU")

    san_list = get_orbit_chain(one_to_one, santas_planet) |> Enum.reverse()
    my_list = get_orbit_chain(one_to_one, my_planet) |> Enum.reverse()

    san_jumps =
      Enum.drop_while(san_list, fn san_plan ->
        Enum.find(my_list, fn my_plan -> my_plan == san_plan end) != nil
      end)
      |> length()

    my_jumps =
      Enum.drop_while(my_list, fn my_plan ->
        Enum.find(san_list, fn san_plan -> san_plan == my_plan end) != nil
      end)
      |> length()

    san_jumps + my_jumps + 2
  end

  def map_orbits(orbit, map) do
    [inner, outer] = orbit

    Map.put(map, outer, inner)
  end

  def get_orbit_chain(map, body_id) do
    case Map.get(map, body_id) do
      "COM" ->
        ["COM"]

      center_body ->
        [center_body | get_orbit_chain(map, center_body)]
    end
  end

  defp read_input do
    {:ok, bin} = File.read("./lib/inputs/six.txt")

    String.split(bin, "\n", trim: true)
    |> Enum.map(fn orbit_string -> String.split(orbit_string, ")", trim: true) end)
  end
end
