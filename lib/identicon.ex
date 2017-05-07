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
  end

  def build_grid(image = %Identicon.Image{hex: hex}) do
    hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
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
