defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """
  def main(input) do
    input |> hash_input |> pick_color |> build_grid |> filter_odd_squares
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list
    %Identicon.Image{hex: hex}
  end

  def pick_color(image) do
    # %Identicon.Image{hex: hex_list} = image
    # [r, g, b | _tail] = hex_list
    # [r, g, b]
    # or you can do this
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = hex |> Enum.chunk(3) |> Enum.map(&mirror_row/1) |> List.flatten |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    # [134, 72, 200]
    [first, second | _tail] = row
    # [134, 72, 200, 72, 134]
    row ++ [second , first]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    new_grid = Enum.filter grid, fn({code, _index}) ->
                rem(code, 2) == 0
              end
    %Identicon.Image{image | grid: new_grid}
  end

end
