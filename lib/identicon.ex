defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  @doc """
  Main transforms a string into an image.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
  end

  def filter_odd_squares(image = %Identicon.Image{grid: grid}) do
#    new_grid = Enum.filter(grid, fn({value, _}) ->
#        rem(value, 2) == 0
#    end)
    new_grid = Enum.filter_map(grid, fn({value, _}) ->
        rem(value, 2) == 0
    end, fn({_, index}) -> index end)
    %Identicon.Image{image | grid: new_grid}
  end

  def build_grid(image = %Identicon.Image{hex: hex}) do
    grid = hex
        |> Enum.chunk(3)
        |> Enum.map(&mirror_row/1)
        |> List.flatten
        |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Mirror the first two values of a 3 columns row and
  return a 5 columns row mirroring around the third value

  ## Example
    iex> Identicon.mirror_row [1 , 2, 3]
    [1 , 2, 3, 2, 1]
  """
  def mirror_row(row = [ first, second | _ ]) do
    row ++ [ second, first ]
  end

  def pick_color(image = %Identicon.Image{hex: [red, green, blue | _ ]}) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
