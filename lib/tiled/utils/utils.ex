defmodule Tiled.Utils.Decoder do
  @moduledoc false

  defmodule InternalDecoder do
    @moduledoc false
    defmacro __before_compile__(_env) do
      quote do
        @spec decode_key_value({:type, String.t()}) :: atom() | nil
        defp decode_key_value({:type, ""}), do: nil
        defp decode_key_value({:type, type}) when is_binary(type), do: type |> String.to_atom()

        @spec decode_key_value({:name, String.t()}) :: atom() | nil
        defp decode_key_value({:name, ""}), do: nil
        defp decode_key_value({:name, name}) when is_binary(name), do: name |> String.to_atom()

        @spec decode_key_value({:properties, map() | nil}) :: Tiled.property_values()
        defp decode_key_value({:properties, properties}), do: properties || %{}

        @spec decode_key_value({:property_types, map() | nil}) :: Tiled.property_types()
        defp decode_key_value({:property_types, types}), do: types || %{}

        defp decode_key_value({key, _} = key_value) when is_atom(key), do: key_value
      end
    end
  end

  defmacro __using__(_) do
    quote do
      @before_compile InternalDecoder
      @spec decode(map(), ({atom(), term()} -> {atom(), term()} | term())) :: struct()
      defp decode(map, transformer \\ & &1) when is_map(map) and is_function(transformer, 1) do
        module = __MODULE__
        module
        |> struct
        |> Map.from_struct()
        |> Map.keys()
        |> Enum.reduce(%{}, fn key, memo ->
          json_key = downcase_key(key)

          case transformer.({key, map[json_key]}) do
            {new_key, value} -> Map.put(memo, new_key, value)
            value -> Map.put(memo, key, value)
          end
        end)
        |> (fn map -> struct(module, map) end).()
      end

      @spec downcase_key(atom() | String.t()) :: atom()
      defp downcase_key(key) when is_atom(key),
        do: key |> Atom.to_string() |> Macro.camelize() |> String.downcase() |> String.to_atom()

      defp downcase_key(key) when is_binary(key),
        do: key |> Macro.camelize() |> String.downcase() |> String.to_atom()
    end
  end

end
