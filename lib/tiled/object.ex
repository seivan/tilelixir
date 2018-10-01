defmodule Tiled.Object do
  alias Tiled.Utils.{Decoder, TypedStruct}

  def new(%{ellipse: true} = ellipse), do: ellipse |> Tiled.Object.Ellipse.new()
  def new(rectangle) when is_map(rectangle), do: rectangle |> Tiled.Object.Rectangle.new()

  defmodule Rectangle do
    use Decoder

    use TypedStruct,
      height: integer(),
      id: integer(),
      name: atom() | nil,
      properties: %{optional(atom) => Tiled.property_value()},
      property_types: %{optional(atom) => Tiled.property_type()},
      rotation: float(),
      type: atom() | nil,
      visible: boolean(),
      width: integer(),
      x: integer(),
      y: integer()

    def new(object) when is_map(object), do: object |> decode(&decode_key_value/1)
  end

  defmodule Ellipse do
    use Decoder

    use TypedStruct,
      ellipse: boolean,
      height: integer(),
      id: integer(),
      name: atom() | nil,
      properties: %{optional(atom) => Tiled.property_value()},
      property_types: %{optional(atom) => Tiled.property_type()},
      rotation: float(),
      type: atom() | nil,
      visible: boolean(),
      width: integer(),
      x: integer(),
      y: integer()

    def new(%{ellipse: true} = ellipse), do: ellipse |> decode(&decode_key_value/1)
  end
end
