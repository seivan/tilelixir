
defmodule Tiled.Utils.TypedStruct do
  @moduledoc false


  defp splice_attributes(attrs) do
    keys = Keyword.keys(attrs)

    quote do
      @enforce_keys unquote(keys)
      defstruct @enforce_keys

      @type t :: %__MODULE__{
              unquote_splicing(attrs)
            }
    end
  end



  defmacro deftypedstruct(attrs) do
    quote do
      import Tiled.Utils.TypedStruct
      unquote(splice_attributes(attrs))
    end
  end

  defmacro __using__(attrs) do
    quote do: Tiled.Utils.TypedStruct.deftypedstruct(unquote(attrs))
  end

end
