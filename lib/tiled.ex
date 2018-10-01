defmodule Tiled do
  @type file_handler :: (String.t() -> String.t()) | {:ok, String.t()} | {:ok | map()} | map()
  @type property_value :: String.t() | number() | boolean()
  @type property_type :: :string | :color | :float | :file | :bool | :int
  @type property_values :: %{optional(atom) => Tiled.property_value()}
  @type property_types :: %{optional(atom) => Tiled.property_value()}

  @spec parse(String.t()) :: Tiled.TileMap.t()
  def parse(json) when is_binary(json) do
    {:ok, value} = parse_json(json)
    value |> Tiled.TileMap.new()
  end

  @spec parse(String.t(), file_handler) :: Tiled.TileMap.t()
  def parse(json, file_handler) when is_binary(json) and is_function(file_handler, 1) do
    json |> Tiled.parse() |> Tiled.load_tile_set_files(file_handler)
  end

  @spec parse_json(String.t()) :: {:ok, map()} | {:error, term()}
  defp parse_json(json), do: Poison.decode(json, keys: :atoms)

  @spec load_tile_set_files(Tiled.TileMap.t(), file_handler) :: Tiled.TileMap.t()
  def load_tile_set_files(%Tiled.TileMap{} = map, file_handler)
      when is_function(file_handler, 1) do
    tile_sets =
      map.tile_sets
      |> Enum.map(fn
        %Tiled.TileSet.Embedded{} = tile_set ->
          tile_set

        %Tiled.TileSet.File{} = tile_set ->
          file_handler.(tile_set.source)
          |> file_tile_to_embedded
          |> Map.merge(%{first_gid: tile_set.first_gid})
      end)

    %{map | tile_sets: tile_sets}
  end

  @spec file_tile_to_embedded(String.t() | {:ok, String.t()} | {:ok, map()} | map()) ::
          Tiled.TileSet.Embedded.t()
  defp file_tile_to_embedded(file_path) when is_binary(file_path),
    do: file_path |> File.read() |> file_tile_to_embedded

  defp file_tile_to_embedded({:ok, json_string}) when is_binary(json_string),
    do: json_string |> Poison.Parser.parse(keys: :atoms) |> file_tile_to_embedded

  defp file_tile_to_embedded({:ok, map}) when is_map(map), do: map |> Tiled.TileSet.Embedded.new()
  defp file_tile_to_embedded(map) when is_map(map), do: map |> Tiled.TileSet.Embedded.new()
end
