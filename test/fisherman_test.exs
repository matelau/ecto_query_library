defmodule FishingSpot.FishermanTest do
  @moduledoc """

  """

  use FishingSpot.DataCase
  import EctoQueryLibray.Factory
  alias FishingSpot.Context.Fish

  describe "FishermanEctoTests" do
    test "Select Fisherman Name" do
      fisherman = insert(:fisherman)
      # Update context to return proper result
      result = Fish.get_fisherman_name(fisherman.id)
      assert result == "Fisherman"
    end

    test "Select Unique Fishermen Names" do
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "something_unique")
      # Update context to return proper result
      results = Fish.get_unique_fishermen_names()
      # assert Enum.count(results) == 1
      result = List.first(results)
      assert result == "something_unique"
    end
  end
end
