defmodule Tiled.Layer do
  alias Tiled.Utils.{Decoder, TypedStruct}

  def new(%{type: "tilelayer"} = layer), do: layer |> Tiled.Layer.TileLayer.new()
  def new(%{type: "objectgroup"} = layer), do: layer |> Tiled.Layer.ObjectLayer.new()
  def new(%{type: "imagelayer"} = layer), do: layer |> Tiled.Layer.ImageLayer.new()

  defmodule TileLayer do
    use Decoder

    use TypedStruct,
      data: list(integer()),
      height: integer(),
      name: atom(),
      opacity: float(),
      properties: %{optional(atom) => Tiled.property_value()},
      property_types: %{optional(atom) => Tiled.property_type()},
      type: :tile_layer,
      visible: boolean(),
      width: integer(),
      x: integer(),
      y: integer()

    def new(%{type: "tilelayer"} = tile_layer), do: tile_layer |> decode(&decode_key_value/1)

    defp decode_key_value({:type, "tilelayer"}), do: :tile_layer
  end

  defmodule ObjectLayer do
    use Decoder

    use TypedStruct,
      color: atom() | nil,
      draw_order: :top_down | :index,
      name: atom(),
      objects: list(Tiled.Object.Rectangle.t() | Tiled.Object.Ellipse.t()),
      opacity: float(),
      properties: %{optional(atom) => Tiled.property_value()},
      property_types: %{optional(atom) => Tiled.property_type()},
      type: :object_group,
      visible: boolean(),
      x: integer(),
      y: integer()

    def new(%{type: "objectgroup"} = object_layer),
      do: object_layer |> decode(&decode_key_value/1)

    defp decode_key_value({:type, "objectgroup"}), do: :object_group

    defp decode_key_value({:objects, objects}) when is_list(objects),
      do: objects |> Enum.map(&Tiled.Object.new/1)

    defp decode_key_value({:draw_order, draw_order}) when is_binary(draw_order) do
      case draw_order do
        "topdown" -> :top_down
        _ -> :index
      end
    end
  end

  defmodule ImageLayer do
    use Decoder

    use TypedStruct,
      image: String.t() | nil,
      name: atom(),
      offset_x: integer,
      offset_y: integer,
      opacity: float(),
      type: :image_layer,
      visible: boolean(),
      x: integer(),
      y: integer()

    def new(%{type: "imagelayer"} = image_layer), do: image_layer |> decode(&decode_key_value/1)

    defp decode_key_value({:type, "imagelayer"}), do: :image_layer
    defp decode_key_value({:image, ""}), do: nil
  end
end
