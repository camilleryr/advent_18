defmodule NoMatterHowYouSliceIt do
  @input File.read("./day_three/input.txt") |> elem(1) |> String.split("\n", trim: true)

  def part_one do
    @input
    |> Enum.reduce(%{}, fn claim_string, acc ->
      [id, x, y, width, height] =
        claim_string
        |> String.replace(~r([#@,:x]), " ", [])
        |> String.split()
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(&elem(&1, 0))

      0..(width - 1)
      |> Enum.reduce(acc, fn width_cord, acc_w ->
        0..(height - 1)
        |> Enum.reduce(acc_w, fn height_cord, acc_h ->
          Map.update(acc_h, "#{x + width_cord},#{y + height_cord}", [id], fn arr -> [id | arr] end)
        end)
      end)
    end)
    |> Enum.filter(fn {_, claims} -> length(claims) > 1 end)
    |> length()
    |> IO.inspect()
  end

  # https://adventofcode.com/2018/day/3#part2
  def part_two do
    @input
    |> Enum.reduce(%{}, fn claim_string, acc ->
      [id, x, y, width, height] =
        claim_string
        |> String.replace(~r([#@,:x]), " ", [])
        |> String.split()
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(&elem(&1, 0))

      0..(width - 1)
      |> Enum.reduce(acc, fn width_cord, acc_w ->
        0..(height - 1)
        |> Enum.reduce(acc_w, fn height_cord, acc_h ->
          Map.update(acc_h, "#{x + width_cord},#{y + height_cord}", [id], fn arr -> [id | arr] end)
        end)
      end)
    end)
    |> Enum.filter(fn {_, claims} -> length(claims) > 1 end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(MapSet.new(), fn sq_in, acc ->
      MapSet.union(acc, MapSet.new(sq_in))
    end)
    |> (&MapSet.difference(MapSet.new(1..length(@input)), &1)).()
  end

  # I DONT KNOW WHY THIS DIDNT WORK - FUCK
  # def part_two do
  #   claims =
  #     @input
  #     |> Enum.map(&deconstruct_claim/1)

  #   claims
  #   |> Enum.reduce_while(
  #     claims,
  #     fn [id, _, _, _, _] = claim, [_h | tail] ->
  #       tail
  #       |> Enum.map(&intersecting_claims(&1, claim))
  #       |> Enum.all?(fn x -> x == true end)
  #       |> case do
  #         true -> {:halt, id}
  #         false -> {:cont, tail}
  #       end
  #     end
  #   )
  # end

  # defp deconstruct_claim(claim) do
  #   claim
  #   |> String.replace(~r([#@,:x]), " ", [])
  #   |> String.split()
  #   |> Enum.map(&Integer.parse/1)
  #   |> Enum.map(&elem(&1, 0))
  # end

  # def intersecting_claims(claim_two, claim_one) do
  #   [_, x, y, width, height] = claim_one
  #   [_, x_2, y_2, width_2, height_2] = claim_two

  #   x > x_2 + width_2 || x + width < x_2 || y > y_2 + height_2 || y + height < y_2
  # end
end
