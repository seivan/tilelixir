defmodule Tiled.TileMap do
  alias Tiled.Utils.{Decoder, TypedStruct}
  use Decoder

  use TypedStruct,
    background_color: String.t() | nil,
    height: pos_integer(),
    infinite: boolean(),
    layers: list(Tiled.Layer.TileLayer | Tiled.Layer.ObjectLayer | Tiled.Layer.ImageLayer),
    next_object_id: non_neg_integer(),
    orientation: :orthogonal | :isometric,
    properties: Tiled.property_values(),
    property_types: Tiled.property_types(),
    render_order: :left_up | :right_up | :right_down | :left_down,
    tiled_version: String.t(),
    tile_height: pos_integer(),
    tile_sets: list(Tiled.TileSet.File | Tiled.TileSet.Embedded | Tiled.TileSet.ImageLayer),
    tile_width: pos_integer(),
    type: :map,
    version: pos_integer(),
    width: pos_integer()

  @spec new(map()) :: t()
  def new(raw_map) when is_map(raw_map), do: raw_map |> decode(&decode_key_value/1)

  defp decode_key_value({:tile_sets, tilesets}) when is_list(tilesets),
    do: tilesets |> Enum.map(&Tiled.TileSet.new/1)

  defp decode_key_value({:layers, layers}) when is_list(layers),
    do: layers |> Enum.map(&Tiled.Layer.new/1)

  defp decode_key_value({:orientation, orientation}) when is_binary(orientation),
    do: orientation |> String.to_atom()

  defp decode_key_value({:render_order, render_order}) when is_binary(render_order),
    do: render_order |> String.replace("-", "_") |> String.to_atom()

    defp decode_key_value({:tiledversion, tiled_version}) when is_binary(tiled_version),
    do: {:tiled_version, tiled_version}

end
