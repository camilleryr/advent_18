defmodule ReposeReord do
  @input File.read("./day_four/input.txt")
         |> elem(1)
         |> String.replace(~r([#\[\]]), " ")
         |> String.split("\n", trim: true)

  def part_one do
    sleep_map()
    |> Enum.sort(fn x, y -> length(elem(x, 1)) > length(elem(y, 1)) end)
    |> hd
    |> reduce_sleep_array()
  end

  defp reduce_sleep_array({id, array}) do
    array
    |> Enum.reduce(%{}, fn n, acc ->
      Map.update(acc, n, 1, fn v -> v + 1 end)
    end)
    |> Enum.sort(fn x, y -> elem(x, 1) > elem(y, 1) end)
    |> hd
    |> elem(0)
    |> Kernel.*(id |> Integer.parse() |> elem(0))
  end

  def part_two do
    sleep_map()
    |> Enum.map(&most_slept_minute/1)
    |> Enum.sort(fn {_, {_, total_1}}, {_, {_, total_2}} -> total_1 > total_2 end)
    |> hd
    |> find_val()
  end

  def find_val({id, {min, _}}) do
    id |> Integer.parse() |> elem(0) |> Kernel.*(min)
  end

  defp most_slept_minute({id, array}) do
    msm =
      array
      |> Enum.reduce(%{}, fn el, acc ->
        Map.update(acc, el, 1, fn v -> v + 1 end)
      end)
      |> Enum.sort(fn x, y -> elem(x, 1) > elem(y, 1) end)
      |> hd

    {id, msm}
  end

  defp sleep_map do
    @input
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&convert_date/1)
    |> Enum.sort_by(&hd/1, &naive_date_sort/2)
    |> Enum.reduce({%{}, nil}, &reduce_func/2)
    |> elem(0)
    |> Enum.map(&mapper/1)
    |> Enum.into(%{})
  end

  defp mapper({id, array}) do
    array =
      array
      |> Enum.chunk_every(2)
      |> Enum.map(&build_range/1)
      |> Enum.flat_map(& &1)

    {id, array}
  end

  defp build_range([second, first]) do
    {{_, _, _}, {_, s, _}} = NaiveDateTime.to_erl(second)
    {{_, _, _}, {_, f, _}} = NaiveDateTime.to_erl(first)
    f..(s - 1)
  end

  defp reduce_func([_, _, id, _, _], {map, _current_id}), do: {map, id}

  defp reduce_func([date, _, _], {map, current_id}) do
    {Map.update(map, current_id, [date], &[date | &1]), current_id}
  end

  defp naive_date_sort(x, y) do
    NaiveDateTime.compare(x, y)
    |> case do
      :gt -> false
      _ -> true
    end
  end

  defp convert_date([date, time | rest]) do
    [
      NaiveDateTime.new(
        date |> Date.from_iso8601() |> elem(1),
        (time <> ":00") |> Time.from_iso8601() |> elem(1)
      )
      |> elem(1)
      | rest
    ]
  end
end
