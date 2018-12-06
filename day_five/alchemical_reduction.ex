defmodule AlchemicalReduction do
  @input File.read("./day_five/input.txt")
         |> elem(1)
         |> String.replace("\n", "")
         |> to_charlist()

  def part_one do
    @input
    |> List.foldr([], &reduce_polylmer/2)
    |> length
  end

  def reduce_polylmer(letter, acc), do: reduce_polylmer(letter, acc, nil)
  def reduce_polylmer(letter, acc, letter), do: acc
  def reduce_polylmer(letter, acc, remove) when abs(letter - remove) == 32, do: acc
  def reduce_polylmer(letter, [], _), do: [letter]

  def reduce_polylmer(letter, [h | t] = acc, _) do
    case abs(letter - h) == 32 do
      false -> [letter | acc]
      true -> t
    end
  end

  def part_two do
    ?a..?z
    |> Enum.reduce(%{}, &reduce_remove/2)
    |> Enum.sort(fn a, b -> elem(a, 1) < elem(b, 1) end)
    |> hd
    |> elem(1)
  end

  def reduce_remove(codepoint, acc) do
    @input
    |> List.foldl([], fn x, y -> reduce_polylmer(x, y, codepoint) end)
    |> length
    |> (&Map.put(acc, codepoint, &1)).()
  end
end
