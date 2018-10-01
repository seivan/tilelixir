defmodule Tiled.TileSet do
  alias Tiled.Utils.{Decoder, TypedStruct}

  @spec new(%{firstgid: integer(), source: String.t()}) :: Tiled.TileSet.File.t()
  def new(%{firstgid: gid, source: file_source} = raw_file_tile_set)
      when is_integer(gid) and is_binary(file_source),
      do: raw_file_tile_set |> Tiled.TileSet.File.new()

  @spec new(%{image: String.t()}) :: Tiled.TileSet.Embedded.t()
  def new(raw_embedded_tile_set) when is_map(raw_embedded_tile_set),
    do: raw_embedded_tile_set |> Tiled.TileSet.Embedded.new()

  defmodule Embedded do
    use Decoder

    use TypedStruct,
      columns: integer,
      first_gid: integer,
      grid:
        %{:orientation => :orthogonal | :isometric, :width => integer(), height: integer()} | nil,
      image: String.t(),
      image_height: integer,
      image_width: integer,
      type: String.t() | nil,
      margin: integer,
      name: atom(),
      spacing: integer,
      tile_count: integer,
      tile_height: integer,
      tile_properties: %{
        optional(integer) => %{optional(atom()) => Tiled.property_value()}
      },
      tile_property_types: %{
        optional(integer) => %{optional(atom()) => Tiled.property_type()}
      },
      tile_width: integer,
      type: :tileset

    @spec new(map()) :: Tiled.TileSet.Embedded.t()
    def new(raw_tile_set) when is_map(raw_tile_set),
      do: raw_tile_set |> decode(&decode_key_value/1)

    defp decode_key_value({:tile_properties, properties}),
      do: properties |> property_keys_to_integer

    defp decode_key_value({:tile_property_types, types}), do: types |> property_keys_to_integer

    defp property_keys_to_integer(properties),
      do:
        properties ||
          %{} |> Enum.reduce(%{}, &Map.put(&2, elem(&1, 0) |> atom_to_integer, elem(&1, 1)))

    defp atom_to_integer(atom), do: atom |> Atom.to_string() |> String.to_integer()
  end

  defmodule File do
    use Decoder

    use TypedStruct,
      first_gid: Integer,
      source: String.t()

    @spec new(%{firstgid: integer(), source: String.t()}) :: t()
    def new(%{firstgid: gid, source: file_source} = raw_file_tile_set)
        when is_integer(gid) and is_binary(file_source),
        do: raw_file_tile_set |> decode()
  end
end
