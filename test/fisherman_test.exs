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
  end
end
