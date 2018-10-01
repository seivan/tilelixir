defmodule Tiled.ObjectTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  doctest Tiled.Object

  property "screwing around" do
    name = StreamData.one_of([StreamData.boolean(), StreamData.string(:alphanumeric)])


    name = gen all name <- name do
      name
    end

    check all list <- list_of(integer()),
      name <- name do
        #IO.inspect name

      assert length(list) == length(:lists.reverse(list))
    end
  end

  describe "Tiled.Object" do

    def helper do
      name = StreamData.one_of([StreamData.boolean(), StreamData.string(:alphanumeric)])


      name = gen all name <- name do
        name
      end

    end

    property "Create Rectangle" do
      check all list <- list_of(integer()),
      name <- helper do
        IO.inspect name

      assert name == name
    end

    end

  end
end
